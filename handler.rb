class Handler
  attr_reader :pages
  def initialize(array_of_pages, error_page)
    @pages = Hash.new(error_page)
    array_of_pages.each do |page|
      @pages[page.resource] = page
    end
  end

  def page_routing(request)
    @pages[request]
  end

end