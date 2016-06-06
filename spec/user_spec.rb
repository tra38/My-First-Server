require_relative '../users'

RSpec.describe "User" do
  it "allows us to retrive user information from a Hash...er...I mean, 'database'" do
    user = USER_TABLE["mattBaker"]
    expect(user.password).to eq("California") 
  end

  it "allows us to access a user based on its UUID" do
    matt = USER_TABLE["mattBaker"]
    matt_id = matt.user_id
    matt_again = User.find_by_user_id(matt_id)
    expect(matt).to eq(matt_again)
  end
end