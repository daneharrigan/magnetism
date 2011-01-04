require 'magnetism/page_not_found'

class DispatchController < ApplicationController
  layout nil

  def show
    page = Page.find_by_path(params[:path] || '')
    # params[:path] is nil when / is requested

    raise Magnetism::PageNotFound if page.nil?

    page.current!
    render :text => Liquify.render(page.template.content)
  rescue Magnetism::PageNotFound
    render :text => '404: Page Not Found', :status => 404
  end
end
