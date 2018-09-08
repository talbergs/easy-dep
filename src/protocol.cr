require "json"

class Protocol

    # macro that defines properties and getters
    JSON.mapping({
        action: String,
        payload: String|JSON::Any|UInt32,
    })

    # parses common communication payload once receaved
    def self.parse(inputJson : String)
        p = self.from_json(inputJson)
        yield p.action, p.payload
    end

    # creates common communication payload to be sent
    def self.newSignal(signal : String)
        JSON.build do |json|
          json.object do
            json.field "action", signal
            json.field "payload" do
                json.object do
                    yield json
                end
            end
          end
        end
    end

    # json string wrapepd in signal
    def self.conf(confStr : String)
        newSignal "conf.gotStr" { |json|
            json.field "data", confStr
        }
    end

    # string wrapepd in signal
    def self.stdout(line : String)
        newSignal "stdoutPanel.addLine" { |json|
            json.field "id", Time.now.epoch_ms.to_s
            json.field "line", line
        }
    end

    # string wrapepd in signal
    def self.stderr(line : String)
        newSignal "stderrPanel.addLine" { |json|
            json.field "id", Time.now.epoch_ms.to_s
            json.field "line", line
        }
    end

    # string wrapepd in signal
    def self.sys(line : String)
        newSignal "sysPanel.addLine" { |json|
            json.field "id", Time.now.epoch_ms.to_s
            json.field "line", line
        }
    end
end

