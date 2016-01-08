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
  def page_routing(request, parameters)
    page = @pages[request]
    namespace = OpenStruct.new(parameters)
    response = ERB.new(page.to_s).result(namespace.instance_eval { binding })
    parameters.each do |key, value|
      response.gsub!("%"+key, value)
    end
    response
  end

end

# class TemplateEngine
#   attr_reader :text, :parameters, :page

#   def initialize(args)
#     @namespace = args[:parameters]
#     @text = args[:text]
#     PARAMETERS = args[:parameters]
#     @page = ERB.new(@text).result
#   end
# end
