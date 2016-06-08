require 'socket'
require_relative 'handler'
require_relative 'uri_parser'
require_relative 'request'
require_relative 'cookie'

class Server
	attr_reader :server, :client, :port, :handler

	def initialize(port, array_of_pages, error_page)
		@port = port
		@server = TCPServer.new port
		@handler = Handler.new(array_of_pages, error_page)
		@client = nil
	end

	def start
		@client = @server.accept
	end

	def stop
		@client.close
	end

	def send_message
		request = Request.new(client)
		uri_parser = URIParser.new(request.uri)
		if request.headers["cookie"]
			cookie = Cookie.new(request.headers["cookie"])
		else
			cookie = Cookie.new("count=0;")
		end
		unless cookie.hash["count"]
			cookie.hash["count"] = 0
		end
		resource = uri_parser.resource
		parameters = uri_parser.parameters
		http_method = uri_parser.http_method
		response = handler.page_routing(resource, http_method, parameters, cookie)
		puts response
		@client.puts response
	end

end