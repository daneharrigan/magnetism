class DispatchController < ApplicationController
  layout nil

  def show
    page = Page.find_by_path(params[:path] || '')
    # params[:path] is nil when / is requested

    raise Magnetism::PageNotFound if page.nil?

    page.current!
    render :text => Liquify.render(page.template.content)
  rescue
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end
end
