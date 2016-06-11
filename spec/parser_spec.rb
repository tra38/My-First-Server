require_relative '../parser.rb'

RSpec.describe "Parser" do

  context "deals with query strings" do

    before do
      request = instance_double("Request", :uri => "GET /home?first=Burt&last=Malkiel")
      @parser = Parser.new(request)
    end

    it "returns the method of an URI" do
      expect(@parser.http_method).to eq("GET")
    end

    it "returns the route of an URI" do
      expect(@parser.resource).to eq("/home")
    end

    it "returns query parameters of an URI" do
      expect(@parser.parameters["first"]).to eq("Burt")
      expect(@parser.parameters["last"]).to eq("Malkiel")
    end
  end

  context "deals with no query strings" do
    before do
      request = instance_double("Request", :uri => "GET /home")
      @parser = Parser.new(request)
    end

    it "returns query parameters of an URI" do
      expect(@parser.parameters).to eq({})
    end

  end

  context "handles invalid query strings" do
    before do
      request = instance_double("Request", :uri => "GET /home?first")
      @parser = Parser.new(request)
    end

    it "returns default query parameters" do
      expect(@parser.parameters).to eq({})
    end

  end

  context "handles POST requests" do
    before do
      request = instance_double("Request", :uri => "POST /home", :headers => { "content" => "user=cat&password=dog"})
      @parser = Parser.new(request)
    end

    it "returns the method of a POST request successfully" do
      expect(@parser.http_method).to eq("POST")
    end

    it "returns the post body of the request" do
      expect(@parser.parameters).to eq({ "user" => "cat", "password" => "dog" })
    end
  end

end