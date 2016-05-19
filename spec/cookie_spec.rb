require_relative '../cookie'

RSpec.describe "Cookie" do

  it "can interpret the Cookie header" do
    cookie = Cookie.new("foo=bar; cat=dog")
    data = cookie.hash
    expect(data["foo"]).to eq("bar")
    expect(data["cat"]).to eq("dog")
  end

  it "can generate Set-Cookie headers" do
    cookie = Cookie.new("foo=bar; cat=dog")
    expect(cookie.headers).to eq("Set-Cookie: foo=bar\r\nSet-Cookie: cat=dog")
  end
  
end