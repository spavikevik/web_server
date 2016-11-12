require 'socket'
require 'json'

Methods = {'GET' => :get_method, 'POST' => :post_method}

def generate_header(status, content_length=0)
  <<-RESP_HEADER
HTTP/1.1 #{status}\r
Date: #{Time.now.ctime}\r
Content-Type: text/html\r
Content-Length: #{content_length}\r\n\r
  RESP_HEADER
end

def vikings_html
  html = ""
  params['viking'].each do |k, v|
    html += "<li>#{k.capitalize}: #{v}</li>"
  end
  html
end

def yield_to_template(template, replacement)
  template.gsub("<%= yield %>", replacement)
end

def get_method(path)
  content = File.read path
end

def post_method(path)
  thanks = File.read "thanks.html"
  yield_to_template thanks, vikings_html
end

def params
  JSON.parse Thread.current['post_data']
end

def create_response(path, method)
  begin
    content = send(method, path)
    status = "200 OK"
  rescue
    content = "<h1>404 NOT FOUND</h1>"
    status = "404 Not Found"
  end
  generate_header(status, content.length) + content
end

server = TCPServer.open(8080)
loop do
  Thread.start(server.accept) do |client|
    i = 0
    while line = client.gets and line !~ /^\s*$/
      if i == 0
        header = line
      end
      i += 1
      if line =~ /Content-Length:\s*([\d]+)/
        content_length = $1.to_i
      end
    end
    header =~ /([A-Z]+)[ ]\/(.+)[ ]([A-Z]+\/\d\.\d)[\r\n][\r\n]/
    Thread.current['post_data'] = client.readpartial(content_length) if $1 == 'POST'
    client.print create_response($2.to_s, Methods[$1])
    client.close
  end
end
