module Admin
  class SupportFilesController < ApplicationController
    def show
      @full_path = "#{Magnetism.root}/app/views/admin/support_files/#{params[:directory]}/#{params[:file_name]}.*"
      files = Dir.glob(@full_path)
      mime_type = Mime::Type.lookup_by_extension(params[:format])

      if files.empty? || mime_type.nil?
        render :nothing => true, :status => 404
      else
        response.headers['Content-Type'] = "#{mime_type}; charset=utf-8"
        content = File.open(files.first).read

        render :text => content 
      end
    end
  end
end
