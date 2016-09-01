require_relative '../pages'
require_relative '../server'
require_relative '../cookie'
require_relative '../users'
require_relative '../web-finger2'

RSpec.describe "Handler" do

	before do
		@handler = Handler.new([HOMEPAGE, LOGIN_PAGE_GET, LOGIN_PAGE_POST], ERROR_PAGE)
		@cookie = Cookie.new("count=1")
	end

	 it "displays /home, without query parameters " do
	 	page = @handler.page_routing("/home", "GET", {}, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 200/
	 	expect(page.to_s).to match /simplest Web Server/
	 	expect(page.to_s).to match /Hello World!/
	 end

	 it "displays /home, with query parameters" do
	 	query_parameters = { "first" => "Burt", "last" => "Malkiel"}
	 	page = @handler.page_routing("/home", "GET", query_parameters, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 200/
	 	expect(page.to_s).to match /simplest Web Server/
	 	expect(page.to_s).to match /Hello Burt Malkiel!/
	 end

	 it "displays error page" do
	 	page = @handler.page_routing("/unknown", "GET", {}, @cookie)
	 	expect(page.to_s).to match /HTTP\/1.1 404/
	 	expect(page.to_s).to match /my 404 error page/
	 end

	 it "allows users to login, if they send the correct HTTP Method" do
	 	page = @handler.page_routing("/login", "POST", {"user" => "mattBaker", "password" => "California" }, @cookie)
	 	expect(page.to_s).to match /You are ready to RSPEC RAILS!/
	 end

	 it "prevents users from logging in, assuming they send the correct HTTP Method to perform a login attempt" do
	 	page = @handler.page_routing("/login", "POST", {"user" => "mattBaker", "password" => "" }, @cookie)
	 	expect(page.to_s).to match /Try again later./
	 end

	 it "provides the user with a form, if the user sends a GET Method" do
	 	page = @handler.page_routing("/login", "GET", {"user" => "mattBaker", "password" => "" }, @cookie)
	 	expect(page.to_s).to match /let's login/
	 end

	 it "successfully escapes data" do
	 	evil_user = User.create_user("<script>alert('Hacked!')</script>", "somethrowawaypassword")
	 	page = @handler.page_routing("/home", "GET", {}, @cookie)
	 	expect(page.to_s).to match /&lt;script&gt;/
	 end

end
