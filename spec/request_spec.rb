require 'stringio'
require_relative '../request'

RSpec.describe "Request" do
  before do
    mock_server_request = StringIO.new("GET / HTTP/1.1\r\nHost: localhost:2000\r\nConnection: keep-alive\r\nCache-Control: max-age=0\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.97 Safari/537.36\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8\r\n\r\n")

    @request = Request.new(mock_server_request)
  end

  it "extracts out the uri successfully" do
    expect(@request.uri).to eq("GET / HTTP/1.1")
  end

  it "can retreive information from a header" do
    expect(@request.headers["cache-control"]).to eq("max-age=0")
  end
end