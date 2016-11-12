require 'socket'
require 'json'

host = 'localhost'
port = 8080
path = '/index.html'

post_data = { :viking => { :name=>"Erik the Red", :email=>"erikthered@theodinproject.com" } }.to_json
header = "POST #{path} HTTP/1.0\r\nContent-Length: #{post_data.length}\r\n\r\n"

socket = TCPSocket.open(host, port)
socket.print (header + post_data)

response = socket.read

headers, body = response.split("\r\n\r\n", 2)
print response
