require "http"
require "./conf"
require "json"

class Proccer
    getter output = Channel(String).new
    getter error = Channel(String).new
    getter exit_status = Channel(Int32).new
    getter sigterm = Channel(Nil).new
    getter pid = 0

    def initialize(@pwd : String?)
    end

    def invoke(script : ScriptConf)
        proc = Process.new(script.bin, script.args, output: :pipe, error: :pipe, chdir: @pwd)
        @pid = proc.pid

        spawn do
            begin while o = proc.error.gets
                @error.send o
            end
            rescue
                # error if proc is killed
            end
        end

        spawn do
            begin while o = proc.output.gets
                @output.send o
            end
            rescue
                # error if proc is killed
            end
        end

        spawn do
            @exit_status.send proc.wait.exit_status
            @pid = 0
        end

        spawn do
            @sigterm.receive
            proc.kill
        end
    end
end

