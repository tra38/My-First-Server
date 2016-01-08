class Page
	attr_reader :page, :code, :bytesize, :resource, :default_parameters

	def initialize(args)
		@page = args[:page]
		@code = args[:code]
		@bytesize = @page.bytesize
		@resource = args[:resource]
		@default_parameters = args[:default_parameters] || {}
	end

	def headers
		<<-EOT
			HTTP/1.1 #{code}
			Content Type: text/html
			Content-Length #{bytesize}
			Connection: close
			EOT
	end

	def to_s
		"#{headers}\n#{page}\nTime is #{Time.now}"
	end
end