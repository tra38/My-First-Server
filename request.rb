class Request
  attr_reader :uri, :headers
  def initialize(client)
    @uri = extract_uri(client)
    @headers = extract_headers(client)
  end

#Handles only the first line from the client's request
  def extract_uri(client)
    client.gets.gsub("\r\n","")
  end

#Handles the rest of the client's request
  def extract_headers(client)
    headers = Hash.new
    client.each_line do |line|
      break if line == "\r\n"
      array = line.gsub("\r\n","").split(/: /)
      key = array[0]
      value = array[1]
      headers["#{key.downcase}"] = "#{value}"
    end
    headers
  end


end