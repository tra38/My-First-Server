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
  def page_routing(request, parameters, cookie = {})
    page = @pages[request]
    combined_hash = parameters.merge(cookie)
    namespace = OpenStruct.new(combined_hash)
    response = ERB.new(page.to_s).result(namespace.instance_eval { binding })
    combined_hash.each do |key, value|
      response.gsub!("%"+key, value)
    end
    response
  end

end