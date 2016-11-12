require 'socket'
require 'json'

def open_socket
  host = 'localhost'
  port = 8080

  TCPSocket.open(host, port)
end

def post_request(socket)
  post_data = { :viking => { :name=>"Erik the Red", :email=>"erikthered@theodinproject.com" } }.to_json
  header = "POST /thanks.html HTTP/1.1\r\nContent-Length: #{post_data.length}\r\n\r\n"
  socket.print (header + post_data)
end

def get_request(socket, path)
  header = "GET #{path} HTTP/1.1\r\n\r\n"
  socket.print header
end

def print_response(socket)
  response = socket.read
  headers, body = response.split("\r\n\r\n", 2)
  response
end

puts "Requesting 'index.html'..."
socket = open_socket
get_request socket, '/index.html'
puts print_response socket

puts "\nPosting data to 'thanks.html'..."
socket = open_socket
post_request socket
puts print_response socket
