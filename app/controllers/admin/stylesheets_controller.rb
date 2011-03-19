module Admin
  class StylesheetsController < MagnetismController
    def show
      @full_path = "#{Magnetism.root}/app/views/admin/stylesheets/#{params[:file_name]}.*"
      files = Dir.glob(@full_path)

      if files.empty?
        render :nothing => true, :status => 404
      else
        response.headers['Content-Type'] = "text/css; charset=utf-8"
        content = File.open(files.first).read
        render :text => content 
      end
    end
  end
end
