require 'magnetism/page_not_found'

class PublicController < ApplicationController
  layout nil
  around_filter :page_not_found
  after_filter :clear_current

  def show
    render :text => Liquify.invoke(@page.template.content)
  end

  private
    def current_page
      return @page if @page

      site = Site.find_by_request(request)
      raise Magnetism::PageNotFound if site.nil?

      site.current!
      @page = site.pages.find_by_path(request)

      raise Magnetism::PageNotFound if @page.nil?

      @page.current!
      return @page
    end

    def clear_current
      Site.clear_current!
      Page.clear_current!
    end

    def page_not_found
      yield
      rescue Magnetism::PageNotFound
        render :nothing => true, :status => 404
    end
end
