require 'net/http'
require 'yaml'

config = YAML.load_file('config/lesson_server.yml')['production']

id = 419
message = 'changed'

uri = URI.parse("http://#{config['host']}/lessons/#{id}/#{message}")
puts uri.to_s
http = Net::HTTP.new(uri.host, uri.port)

if uri.scheme == 'https'
  puts 'HTTPS!'
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end
#http.set_debug_output $stderr

request = Net::HTTP::Post.new(uri.request_uri)

http.start do |h|
  response = h.request(request)
  p response
  puts response.code
end
