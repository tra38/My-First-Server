class Parser
  attr_reader :http_method, :resource, :parameters

  def initialize(request)
    request = request.split(" ")
    @http_method = request[0]
    query = request[1].split("?")
    @resource = query[0]
    @parameters = hashify(query[1])
  end

  def hashify(parameters)
    parameter_hash = {}
    if parameters
      paramater_array = parameters.split("&")
      paramater_array.each do |key_value_pair|
        key, value = key_value_pair.split("=")
        parameter_hash[key] = value unless value == nil
      end
    end
    parameter_hash
  end

end