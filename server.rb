require 'socket'

matt_baker_quote = %{User: Matt Baker
	Favorite Quote:
	There is science, logic, reason;
	there is thought verified by experience.
	And then there is California. --Edward Abbey}

class Handler
	attr_reader :server, :client, :port, :pages, :error
	def initialize(array_of_pages, error_page)
		@pages = array_of_pages
		@error = error_page
	end

	def page_routing(request)
		pages.each do |page|
			return page if page.resource == request
		end
		return error
	end

end

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