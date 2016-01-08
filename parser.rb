class Parser
  attr_reader :http_method, :uri

  def initialize(request)
    request = request.split(" ")
    @http_method = request[0]
    @uri = request[1]
  end

end