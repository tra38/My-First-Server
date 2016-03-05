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
      cookie_hash["#{key}"] = value
    end
    cookie_hash
  end

end