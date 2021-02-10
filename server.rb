# frozen_string_literal: true

require 'socket'

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  
  puts request_line

  lines = request_line.split(' ')
  http_method = lines.shift
  path, query = lines.shift.split('?')
  query = query.split('&').map { |ele| ele.split('=') }.to_h

  client.puts 'HTTP/1.1 200 OK'
  client.puts "Content-Type: text/plain\r\n\r\n"
  client.puts request_line
  client.puts 'HTTP method: ' + http_method
  client.puts 'path: ' + path
  client.puts 'query: ' + query.to_s

  client.close
end
