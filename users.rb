USER_TABLE = {}

class User
  attr_accessor :visits
  attr_reader :password

  def initialize(password)
    @visits = 0
    @password = password
  end

  def self.create_user(username, password)
    user = User.new(password)
    USER_TABLE[username] = user
  end
end

User.create_user("mattBaker", "California")