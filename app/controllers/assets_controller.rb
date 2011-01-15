class AssetsController < ApplicationController
  def show
    begin
      site = Site.first(:conditions => { :domain => request.domain, :key => params[:site_key] })
      templates = site.theme.templates.send(params[:directory]) if %W(stylesheets javascripts).include? params[:directory]
      template = templates.first(:conditions => [ 'name LIKE ?', params[:file_name]+'%' ])

      content_type = case params[:directory]
          when 'stylesheets'
            'text/css'
          when 'javascripts'
            'text/javascript'
        end

      response.headers['Content-Type'] = "#{content_type}; charset=utf-8"
      render :text => template.content
    rescue
      render :text => '404: Page Not Found', :status => 404
    end
  end
end
