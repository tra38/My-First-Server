class Cookie
  attr_reader :hash

  def initialize(cookie_string)
    @hash = process(cookie_string)
  end

  def process(cookie_string)
    cookie_hash = {}
    cookie_string.split("; ").each do |key_value_pair|
      array = key_value_pair.split("=")
      key = array[0]
      value = array[1]
      # integer regex - http://stackoverflow.com/a/1235990/4765379
      if (/\A[-+]?\d+\z/ === value)
        value = value.to_i
      end
      cookie_hash["#{key}"] = value
    end
    cookie_hash
  end

  def headers
    string = ""
    last_key = hash.keys.last
    hash.each do |key, value|
      if key == last_key
        string << "Set-Cookie: #{key}=#{value}"
      else
        string << "Set-Cookie: #{key}=#{value}\r\n"
      end
    end
    string
  end


end