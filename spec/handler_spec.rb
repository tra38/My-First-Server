require_relative '../pages'
require_relative '../server'
require_relative '../cookie'

RSpec.describe "Handler" do
	before do
		@sample_page = Page.new(
		page: %{
		<html>
		<head>
			<title>Welcome</title>
		</head>
		<body>
		<% if first && last %>
			<h1>Hello %first %last!</h1>
		<% else %>
			<h1>Hello World!</h1>
		<%end%>
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

		@cookie = Cookie.new("count=1")
	end

	 it "displays /home, without query parameters " do
	 	page = @handler.page_routing("/home", {}, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 200/
	 	expect(page.to_s).to match /simplest Web Server/
	 	expect(page.to_s).to match /Hello World!/
	 end

	 it "displays /home, with query parameters" do
	 	query_parameters = { "first" => "Burt", "last" => "Malkiel"}
	 	page = @handler.page_routing("/home", query_parameters, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 200/
	 	expect(page.to_s).to match /simplest Web Server/
	 	expect(page.to_s).to match /Hello Burt Malkiel!/
	 end

	 it "displays error page" do
	 	page = @handler.page_routing("/unknown", {}, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 404/
	 	expect(page.to_s).to match /my 404 error page/
	 end

end
