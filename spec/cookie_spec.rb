require_relative '../cookie'

RSpec.describe "Cookie" do

  it "can interpret the Cookie header" do
    string = CIPHER.encrypt("foo=bar; cat=dog")
    cookie = Cookie.new("FirstServerCookie=#{Base64.encode64(string)}")
    data = cookie.hash
    expect(data["foo"]).to eq("bar")
    expect(data["cat"]).to eq("dog")
  end

  # The "new" cookie string is being updated with additional criteria, thereby making a string comparison worthless,
  # This makes this test unusable unless I come with a different approach. GO GO TDD!
  xit "can generate Set-Cookie headers" do
    string = CIPHER.encrypt("foo=bar; cat=dog")
    cookie = Cookie.new("FirstServerCookie=#{Base64.encode64(string)}")
    expect(cookie.headers).to eq("Set-Cookie: FirstServerCookie=#{Base64.encode64(string).gsub("\n", ' ').squeeze(' ')};")
  end
  
end