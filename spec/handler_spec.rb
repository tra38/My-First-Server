require_relative '../pages'
require_relative '../server'

RSpec.describe "Handler" do
	before do
		@sample_page = Page.new(
		page: %{
		<html>
		<head>
			<title>Welcome</title>
		</head>
		<body>
			<h1>Hello World!</h1>
			<p>Welcome to the world's simplest Web Server.</p>
			<p><img src='http://i.imgur.com/A3crbYQ.gif'></p>
		</body>
		</html>
		},
		code: 200, resource: "/home")

		@error_page = Page.new(
			page: %{
		<html>
		<head>
	  		<title>404 Error Page</title>
		</head>
		<body>
	  		<strong><p>This is my 404 error page.</p></strong>
		</body>
		</html>
		},
		code: 404, resource: nil)

		@handler = Handler.new([@sample_page], @error_page)
	end

	 it "displays /home" do
	 	page = @handler.page_routing("/home")
	 	expect(page.to_s).to match /HTTP\/1.1 200/
	 	expect(page.to_s).to match /simplest Web Server/
	 end

	 it "displays error page" do
	 	page = @handler.page_routing("/unknown")
	 	expect(page.to_s).to match /HTTP\/1.1 404/
	 	expect(page.to_s).to match /my 404 error page/
	 end
end
