# frozen_string_literal: true

require 'socket'

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(' ')
  path, params, = path_and_params.split('?')
  params = (params || '').split('&').map { |ele| ele.split('=') }.to_h

  [http_method, path, params]
end

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  puts request_line

  # client.puts 'HTTP/1.1 200 OK'
  # client.puts "Content-Type: text/plain\r\n\r\n"
  # client.puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts 'HTTP/1.0 200 OK'
  client.puts 'Content-Type: text/html'
  client.puts
  client.puts '<html>'
  client.puts '<body>'
  client.puts '<pre>'
  # Debugging Values
  client.puts 'HTTP method: ' + http_method
  client.puts 'path: ' + path
  client.puts 'params: ' + params.to_s
  client.puts '</pre>'

  client.puts '<h1>Counter</h1>'

  number = params['number'].to_i
  client.puts "<p>The current number is #{number}</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"
  client.puts '</body>'
  client.puts '</html>'
  client.close
end
