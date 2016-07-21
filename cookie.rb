require 'base64'

class Cookie
  attr_reader :hash

  def initialize(cookie_string)
    @hash = process(cookie_string)
  end

  def process(cookie_string)
    normal_cookie_hash = interpret_cookie_string(cookie_string)
    if normal_cookie_hash["FirstServerCookie"]
      our_actual_cookie = CIPHER.decrypt(Base64.decode64(normal_cookie_hash["FirstServerCookie"]))
      final_cookie_hash = interpret_cookie_string(our_actual_cookie)
    else
      # construct brand new cookie_hash that will unify the prexisting cookie variables into a more 'secure' cookie, with a whitelist of variables
      final_cookie_hash = Hash.new
      ["count", "user_id", "user visits"].each do |key|
        final_cookie_hash[key] = normal_cookie_hash[key]
      end
      final_cookie_hash
    end
  end

  def headers
    string = ""
    last_key = hash.keys.last
    hash.each do |key, value|
      if key == last_key
        string << "#{key}=#{value};"
      else
        string << "#{key}=#{value}; "
      end
    end
    "Set-Cookie: FirstServerCookie=#{Base64.encode64(CIPHER.encrypt(string)).gsub("\n", ' ').squeeze(' ')};"
  end

  private

  def interpret_cookie_string(cookie_string)
    hash = Hash.new
    cookie_string.split("; ").each do |key_value_pair|
      array = key_value_pair.split("=")
      key = array[0]
      value = array[1]
      # integer regex - http://stackoverflow.com/a/1235990/4765379
      if (/\A[-+]?\d+\z/ === value)
        value = value.to_i
      end
      hash["#{key}"] = value
    end
    hash
  end


end