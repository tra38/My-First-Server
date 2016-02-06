require 'socket'
require 'ostruct'
require_relative 'handler'
require_relative 'uri_parser'

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
		uri_parser = URIParser.new(request.uri)
		resource = uri_parser.resource
		parameters = uri_parser.parameters
		response = handler.page_routing(resource, parameters)
		@client.puts response
	end

	def get_headers
		request = OpenStruct.new
		request.uri = @client.gets.gsub("\r\n","")
		@client.each_line do |line|
			break if line == "\r\n"
			array = line.gsub("\r\n","").split(/: /)
			key = array[0]
			value = array[1]
			request.send("#{key.downcase}=", value)
		end
		request
	end

end