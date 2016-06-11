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
    content_length = headers["content-length"].to_i
    if (content_length > 0)
      headers["content"] = extract_content(client, content_length)
    end
    puts headers
    headers
  end

# http://stackoverflow.com/questions/24656175/how-do-i-read-a-in-incoming-post-multipart-request-using-ruby-and-tcpserver
# Will need to study the 'recv' method  more carefully to figure out why I need to specify the content_length instead of trying to
# read everything, line by line
  def extract_content(client, content_length)
    client.recv(content_length)
  end


end