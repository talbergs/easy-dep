require "http"

class WsClient

    @send_chan = Channel(String).new
    @recv_chan = Channel(String).new
    @disconnected_chan = Channel(Bool).new

    def initialize(@sock : HTTP::WebSocket, @id : UInt32)
        spawn do
            @sock.send @send_chan.receive
        end
        @sock.on_message do |msg|
            @recv_chan.send msg
        end
        @sock.on_close do
            @disconnected_chan.send true
        end
    end

    def disconnected_chan : Channel(Bool)
        @disconnected_chan
    end

    def id : UInt32
        @id
    end

    def recv_chan : Channel(String)
        @recv_chan
    end

    def send_chan : Channel(String)
        @send_chan
    end

    def sock : HTTP::WebSocket
        @sock
    end

    def send(msg : String) : Void
        @sock.send msg
    end

end

