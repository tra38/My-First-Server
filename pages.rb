class Page
	attr_reader :page, :code, :bytesize, :resource, :cookie_modifiers
	attr_accessor :additional_headers

	def initialize(args)
		@page = args[:page]
		@code = args[:code]
		@resource = args[:resource]
		@additional_headers = args[:additional_headers]
		@cookie_modifiers = args[:cookie_modifiers]
	end

	def headers
		headers_array = []
		headers_array << "HTTP/1.1 #{code}"
		headers_array << "Content Type: text/html"
		headers_array << additional_headers if additional_headers
		headers_array << "Connection: close"
		headers_array.join("\r\n")
	end

	def to_s
		"#{headers}\r\n#{page}\nTime is #{Time.now}"
	end

end