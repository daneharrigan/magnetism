class DispatchController < ApplicationController
  def show
    page = Page.find_by_path(params[:path] || '')
    raise Magnetism::PageNotFound if page.nil?

    render :text => page.template.content
  rescue
      render :text => 'Page not found'
  end
end
