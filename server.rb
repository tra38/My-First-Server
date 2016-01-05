require 'socket'
require_relative 'handler'

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
		request = @client.gets.split(" ")[1]
		page = handler.page_routing(request)
		@client.puts page.to_s
	end

end