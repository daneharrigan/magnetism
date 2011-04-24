require 'magnetism/page_not_found'

class PublicController < ApplicationController
  include Magnetism::Cache

  layout nil
  around_filter :page_exceptions
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

      if @page.nil?
        page_redirect = current_site.redirects.by_url(request.fullpath).first
        raise Magnetism::PageNotFound if page_redirect.nil?

        raise Magnetism::PageRedirect.new(page_redirect.page)
      end

      @page.current!
      return @page
    end

    def clear_current
      Site.clear_current!
      Page.clear_current!
    end

    def page_exceptions
      yield
      rescue Magnetism::PageRedirect => e
        redirect_to e.page.permalink, :status => 301
      rescue Magnetism::PageNotFound
        render :nothing => true, :status => 404
    end
end

