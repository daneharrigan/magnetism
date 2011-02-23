require 'magnetism/page_not_found'

class DispatchController < ApplicationController
  include Magnetism::Cache

  layout nil
  after_filter :clear_current

  def show
    site = Site.first(:conditions => { :domain => request.domain })
    site.current!

    page = site.pages.find_by_path(params[:path] || '')
    # params[:path] is nil when / is requested

    raise Magnetism::PageNotFound if page.nil?

    page.current!
    render :text => Liquify.invoke(page.template.content)
  rescue Magnetism::PageNotFound
    render :nothing => true, :status => 404
  end

  private
    def clear_current
      Site.clear_current!
      Page.clear_current!
    end
end
