require 'magnetism/page_not_found'

class DispatchController < ApplicationController
  include Magnetism::Cache

  layout nil
  around_filter :page_not_found
  after_filter :clear_current

  def show
    if current_page.comment?
      current_page.comments.create({ :author_ip => request.ip }.merge(params[:comment]))
      redirect_to current_page.permalink
    else
      render :text => Liquify.invoke(current_page.template.content)
    end
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
