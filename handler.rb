require 'erb'
require 'ostruct'
require 'cgi'

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
  def page_routing(request, http_method, parameters, cookie, request_headers)
    page = @pages[http_method][request]
    if page.redirect?(cookie.hash)
      page.redirect_headers
    else
      modify_states(cookie.hash, parameters, page.modifiers) if page.modifiers
      page.additional_headers = cookie.headers
      combined_hash = parameters.merge(cookie.hash)
      namespace = OpenStruct.new(combined_hash)
      page_template = page.create_template(request_headers)
      response = ERB.new(page_template).result(namespace.instance_eval { binding })
      combined_hash.each do |key, value|
        escaped_html = CGI::escapeHTML(value.to_s)
        response.gsub!("%"+key, escaped_html)
      end
      response
    end
  end

  private
  def modify_states(cookie_hash, parameters, modifiers)
    modifiers.each do |command|
      self.instance_eval(command)
    end
  end

end