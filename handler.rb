require 'erb'
require 'ostruct'

class Handler
  attr_reader :pages
  def initialize(array_of_pages, error_page)
    @pages = Hash.new(error_page)
    array_of_pages.each do |page|
      @pages[page.resource] = page
    end
  end

#Elements of this code was inspired by tokland, from StackOverflow.
#Source: http://stackoverflow.com/a/8293786
  def page_routing(request, parameters, cookie)
    page = @pages[request]
    modify_cookie(page.cookie_modifiers, cookie) if page.cookie_modifiers
    modify_parameters(page.parameter_modifiers, parameters) if page.parameter_modifiers
    page.additional_headers = cookie.headers
    combined_hash = parameters.merge(cookie.hash)
    namespace = OpenStruct.new(combined_hash)
    response = ERB.new(page.to_s).result(namespace.instance_eval { binding })
    combined_hash.each do |key, value|
      response.gsub!("%"+key, value.to_s)
    end
    response
  end

  def modify_cookie(cookie_modifiers, cookie)
    cookie_modifiers.each do |command|
      cookie.instance_eval(command)
    end
  end

  def modify_parameters(parameter_modifiers, parameters)
    parameter_modifiers.each do |command|
      parameters.instance_eval(command)
    end
  end

end