require "json"
require "colorize"

class ScriptConf
    JSON.mapping(
        bin: {
            type: String,
            default: "bash"
        },
        args: Array(String)?
    )
end

class WebHookConf
    JSON.mapping(
        name: String?,
        path: String,
        queryString: String?,
        script: ScriptConf,
    )
end

class RootConf
    JSON.mapping(
        hooks: {
            type: Array(WebHookConf),
            default: [] of WebHookConf
        }
    )
end

class Conf
    @data : RootConf
    @dataSrc : JSON::PullParser
    @fileToWatch : String = ""

    def pollable? : Bool
        @fileToWatch != ""
    end

    def to_json : String
        @data.to_json
    end

    def initialize(file : String?)
        if file && File.file? file
            @dataSrc = JSON::PullParser.new File.read file
            @fileToWatch = file
        else
            puts "Warning: using default config..".colorize.yellow
            if file
                puts "Warning: because '#{file}' is not a file.".colorize.yellow
            end
            @dataSrc = JSON::PullParser.new "{}"
        end
        @data = RootConf.new(@dataSrc)

        if pollable?
            spawn do
                poll 1.seconds
            end
        end
    end

    def on_invalid(&block)
        @on_invalid_cb = block
    end

    def on_update(&block)
        @on_update_cb = block
    end

    def data : RootConf
        @data
    end

    def get_script(index : UInt32): Tuple(ScriptConf, String?)
        hook = @data.hooks[index]
        return hook.script, hook.name
    end

    # todo improve matcher
    def matchWebhook(env : HTTP::Server::Context): ScriptConf?
        if j = data
            j.hooks.each { |h|
                if env.request.path == h.path
                    return h.script
                end
            }
        end

        return nil
    end

    def updateConfFile(contents : String)
        if pollable?
            data = RootConf.from_json(contents)
            File.write @fileToWatch, data.to_pretty_json
        else
            @data = RootConf.from_json(contents)
        end
    end

    def poll(interval : Time::Span)
        old_mtime = File.info(@fileToWatch).modification_time
        loop do
            sleep interval
            current_mtime = File.info(@fileToWatch).modification_time
            if old_mtime != current_mtime
                puts "Conf file chnged.".colorize.green
                old_mtime = current_mtime
                conf_io = File.open(@fileToWatch)
                begin
                    @dataSrc = JSON::PullParser.new File.read @fileToWatch
                    @data = RootConf.new(@dataSrc)
                    if cb = @on_update_cb
                        cb.call
                    end
                    puts "Config updated #{Time.new}".colorize.green
                rescue
                    if cb = @on_invalid_cb
                        cb.call
                    end
                    puts "Config not valid #{Time.new}".colorize.red
                end
            end
        end
    end

end

