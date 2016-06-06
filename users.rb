require 'securerandom'

USER_TABLE = {}

class User
  attr_accessor :visits
  attr_reader :password
  attr_reader :user_id

  def initialize(password)
    @visits = 0
    @password = password
    @user_id = SecureRandom.uuid
  end

  def self.create_user(username, password)
    user = User.new(password)
    USER_TABLE[username] = user
  end

  def self.find_by_user_id(user_id)
    USER_TABLE.each do |key, value|
      if value.user_id == user_id
        return value
      end
    end
    nil
  end
  
end

User.create_user("mattBaker", "California")

# Should I use IDs to keep track of users? Or should I store the username and password directly into the cookie? Do I store the entire user object into the Cookie itself? Serializing the object? Ugh.