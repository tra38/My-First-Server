class Page
	attr_reader :page, :code, :bytesize, :resource

	def initialize(args)
		@page = args[:page]
		@code = args[:code]
		@bytesize = @page.bytesize
		@resource = args[:resource]
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