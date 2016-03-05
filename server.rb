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
			cookie_hash = Cookie.new(request.headers["cookie"]).hash
			puts "#{cookie_hash}"
		else
			cookie_hash = {}
			puts "No cookie sadly"
		end
		resource = uri_parser.resource
		parameters = uri_parser.parameters
		response = handler.page_routing(resource, parameters, cookie_hash)
		puts response
		@client.puts response
	end

end