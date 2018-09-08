require "http"
require "./ws_client"
require "./proccer"
require "./protocol"
require "colorize"
require "./conf"

# holds ws clients, welcomes and informs them
# invokes scripts, and queues them if needed
class Kernel
    @rand = Random.new
    @clients = Hash(UInt32, WsClient).new
    @queue = [] of ScriptConf

    def initialize(@proccer : Proccer, @conf : Conf)
        @conf.on_update do
            send_all Protocol.sys "Config updated."
            send_all Protocol.conf @conf.to_json
        end

        @conf.on_invalid do
            send_all Protocol.sys "Invalid json confg, using previous config."
        end

        spawn do
            while o = @proccer.error.receive
                send_all Protocol.stderr o
            end
        end

        spawn do
            while o = @proccer.output.receive
                send_all Protocol.stdout o
            end
        end

        spawn do
            while o = @proccer.exit_status.receive
                send_all Protocol.sys "Exit code: #{o}"
            end
        end

        spawn do
            while true
                sleep 1.seconds
                if @queue.size > 1
                    send_all Protocol.sys "Queue size: #{@queue.size}"
                    @proccer.invoke @queue.shift
                end
            end
        end
    end

    def on_webhook(ctx : HTTP::Server::Context): String?
        ctx.response.status_code = 201
        if script = @conf.matchWebhook ctx
            if @proccer.pid != 0
                @queue << script
                return "queued"
            else
                @proccer.invoke script
                return "runnin"
            end
        end
        "no match"
    end

    def send(id : UInt32, msg : String)
        @clients[id].send msg
    end

    def send_all(msg : String)
        @clients.each_key { |id|
            send id, msg
        }
    end

    def send_all_but(id : UInt32, msg : String)
        @clients.each_key { |iid|
            if id != iid
                send iid, msg
            end
        }
    end

    def on_new_ws(s : HTTP::WebSocket)
        # storing clinet in hashmap
        c = WsClient.new s, @rand.next_u
        @clients[c.id] = c

        # proxy event on disconnect
        spawn do
            while evt = c.disconnected_chan.receive
                puts "DISCONNECTED (#{c.id})".colorize.yellow
                @clients.delete(c.id)
            end
        end

        # proxy client issued actions
        spawn do
            while msg = c.recv_chan.receive
                # todo channel per actionStr REFACTOR!!!
                Protocol.parse(msg) do |actionStr, payload|
                    puts actionStr.colorize.green
                    pp! payload

                    case actionStr
                    when "sigterm"
                        if @proccer.pid != 0
                            @proccer.sigterm.send(nil)
                            send_all Protocol.sys "Process(#{@proccer.pid}) stopped manually."
                        else
                            send_all Protocol.sys "No running process."
                        end
                    when "updateConf"
                        @conf.updateConfFile(payload.as(String))
                    when "invokeScriptAtIndex"
                        script, name = @conf.get_script payload.as(UInt32)
                        if @proccer.pid != 0
                            send_all Protocol.sys "Currently there is process running. Stop it first."
                        else
                            send_all Protocol.sys "Invoked script: '#{name}'"
                            spawn do
                                @proccer.invoke script
                            end
                        end
                    when "loadConf"
                        send_all Protocol.conf @conf.to_json
                    end
                end
            end
        end

        # welcoming new client
        send c.id, Protocol.sys "Hi, #{c.id}."

        # notifying others that one more is online
        msg = "Connected client of id: (#{c.id}). Now #{@clients.size} clients online"
        send_all_but c.id, Protocol.sys msg

        # sends current config to bootstrap new client's web UI
        send c.id, Protocol.conf @conf.to_json

        # bind current process output into client
        if @proccer.pid != 0
            send c.id, Protocol.sys "Observing process id: #{@proccer.pid}."
        else
            send c.id, Protocol.sys "No process running."
        end
    end

end

