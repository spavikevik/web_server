require 'socket'
Methods = {'GET' => :get_method, 'POST' => :post_method}

def get_method(path)
  content = ""
  File.open(path, 'r') do |f|
    content = f.read
  end
  content
end

def create_response(path, method)
  begin
    content = send(method, path)
    status = "200 OK"
  rescue
    status = "404 Not Found"
  end

  header = <<-RESP_HEADER
HTTP/1.1 #{status}\r
Date: #{Time.now.ctime}\r
Content-Type: text/html\r
Content-Length: #{content.length}\r\n\r
  RESP_HEADER

  header += content
end

server = TCPServer.open(8080)
loop do
  client = server.accept
  client_request = client.gets
  puts client_request
  client_request =~ /([A-Z]+)[ ]\/(.+)[ ]([A-Z]+\/\d\.\d)[\r\n][\r\n]/
  # unless Methods.include?($1)
  #   client.puts "Illegal request. Closing connection"
  #   client.close
  # end
  client.print create_response($2.to_s, Methods[$1])
  client.close
end
