class Parser
  attr_reader :http_method, :resource, :parameters

  def initialize(request)
    uri = uri_parse(request)
    @http_method = uri[0]
    query = uri[1].split("?")
    @resource = query[0]
    handle_parameters(request, query)
  end

  def uri_parse(request)
    request.uri.split(" ")
  end

  def handle_parameters(request, query)
    if @http_method == "POST"
      @parameters = hashify(request.headers["content"])
    else
      @parameters = hashify(query[1])
    end
  end

  def hashify(parameters)
    parameter_hash = {}
    if parameters
      paramater_array = parameters.split("&")
      paramater_array.each do |key_value_pair|
        key, value = key_value_pair.split("=")
        parameter_hash[key] = CGI.unescape(value) unless value == nil
      end
    end
    parameter_hash
  end

end