class Handler
  attr_reader :pages
  def initialize(array_of_pages, error_page)
    @pages = Hash.new(error_page)
    array_of_pages.each do |page|
      @pages[page.resource] = page
    end
  end

  def page_routing(request, parameters)
    page = @pages[request]
    default_parameters = page.default_parameters
    parameters = default_parameters.update(parameters)
    response = page.to_s
    parameters.each do |key, value|
      response.gsub!("%"+key, value)
    end
    response
  end

end