require 'socket'
require_relative 'handler'
require_relative 'parser'

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
		request = get_headers
		p request
		parser = Parser.new(request[0])
		resource = parser.resource
		parameters = parser.parameters
		response = handler.page_routing(resource, parameters)
		@client.puts response
	end

	def get_headers
		array = []
		while true
			line = @client.gets
			break if line=="\r\n"
			array << line.gsub("\r\n","")
		end
		array
	end

end