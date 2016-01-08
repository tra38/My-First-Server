require_relative '../parser.rb'

RSpec.describe "Parser" do

  before do
    request = "GET /home"
    @parser = Parser.new(request)
  end

  it "returns the method of an URI" do
    expect(@parser.http_method).to eq("GET")
  end

  it "returns the route of an URI" do
    expect(@parser.uri).to eq("/home")
  end

end