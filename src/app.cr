require "kemal"
require "http"
require "./proccer"
require "./conf"
require "./ws_client"
require "./kernel"

#
# kemal configuration
#
logging false
public_folder "client/dist"

#
# kernel scaffold
#
conf = Conf.new ARGV[0]?
proccer = Proccer.new ARGV[1]?
kernel = Kernel.new proccer, conf

#
# webhooks entry
#
get "/*" do |env|
    kernel.on_webhook env
end

#
# dashboard entry
#
get "/" do |env|
    send_file env, "client/dist/index.html"
end

#
# ws clients
#
ws "/" do |s|
    kernel.on_new_ws s
end

puts "visit http://0.0.0.0:3000"
Kemal.run

