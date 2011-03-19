module Admin
  class JavascriptsController < ApplicationController
    def show
      @full_path = "#{Magnetism.root}/app/views/admin/javascripts/#{params[:file_name]}.*"
      files = Dir.glob(@full_path)

      if files.empty?
        render :nothing => true, :status => 404
      else
        content = File.open(files.first).read

        response.headers['Content-Type'] = "text/javascript; charset=utf-8"
        render :text => content 
      end
    end
  end
end
