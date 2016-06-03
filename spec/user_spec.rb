require_relative '../users'

RSpec.describe "User" do
  it "allows us to retrive user information from a Hash...er...I mean, 'database'" do
    user = USER_TABLE["mattBaker"]
    expect(user.password).to eq("California") 
  end

end