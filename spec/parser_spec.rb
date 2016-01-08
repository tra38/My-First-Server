require_relative '../parser.rb'

RSpec.describe "Parser" do

  context "deals with query strings" do

    before do
      request = "GET /home?first=Burt&last=Malkiel"
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
      request = "GET /home"
      @parser = Parser.new(request)
    end

    it "returns query parameters of an URI" do
      expect(@parser.parameters).to eq({})
    end

  end

end