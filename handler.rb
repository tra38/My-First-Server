require 'erb'
require 'ostruct'
require 'pry'

class Handler
  attr_reader :pages
  def initialize(array_of_pages, error_page)
    @pages = Hash.new(error_page)
    @pages["GET"] = Hash.new(error_page)
    @pages["POST"] = Hash.new(error_page)
    array_of_pages.each do |page|
      @pages[page.http_method][page.resource] = page
    end
  end

#Elements of this code was inspired by tokland, from StackOverflow.
#Source: http://stackoverflow.com/a/8293786
  def page_routing(request, http_method, parameters, cookie)
    page = @pages[http_method][request]
    modify_states(cookie.hash, parameters, page.modifiers) if page.modifiers
    page.additional_headers = cookie.headers
    combined_hash = parameters.merge(cookie.hash)
    namespace = OpenStruct.new(combined_hash)
    response = ERB.new(page.to_s).result(namespace.instance_eval { binding })
    combined_hash.each do |key, value|
      response.gsub!("%"+key, value.to_s)
    end
    response
  end

  private
  def modify_states(cookie_hash, parameters, modifiers)
    modifiers.each do |command|
      self.instance_eval(command)
    end
  end

end