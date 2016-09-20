class Page
	attr_reader :page, :code, :bytesize, :resource, :modifiers, :http_method, :redirect_criteria, :redirect_url, :json
	attr_accessor :additional_headers

	def initialize(args)
		@page = args[:page]
		@http_method = args[:http_method]
		@code = args[:code]
		@resource = args[:resource]
		@additional_headers = args[:additional_headers]
		@modifiers = args[:modifiers]
		@redirect_criteria = args[:redirect_criteria]
		@redirect_url = args[:redirect_url]
		@json = args[:json]
	end

	def headers
		headers_array = []
		headers_array << "HTTP/1.1 #{code}"
		if json
			headers_array << "Content Type: application/json"
		else
			headers_array << "Content Type: text/html"
		end
		headers_array << additional_headers if additional_headers
		headers_array << "Connection: close"
		headers_array.join("\r\n")
	end

	def redirect?(cookie_hash)
		if redirect_criteria
			self.instance_eval(redirect_criteria)
		else
			false
		end
	end

	def redirect_headers
		headers_array = []
		headers_array << "HTTP/1.1 303 See Other"
		headers_array << "Location: #{redirect_url}"
		headers_array.join("\r\n")
	end

	def to_s
		"#{headers}\r\n#{page}\nTime is #{Time.now}"
	end

end