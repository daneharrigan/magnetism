require 'magnetism/page_not_found'

class PublicController < ApplicationController
  include Magnetism::Cache

  layout nil
  around_filter :page_not_found
  after_filter :clear_current

  private
    def current_site
      return @site if @site

      @site = Site.find_by_request(request)
      raise Magnetism::PageNotFound if @site.nil?

      @site.current!

      return @site
    end

    def current_page
      return @page if @page

      @page = current_site.pages.find_by_path(request)

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

