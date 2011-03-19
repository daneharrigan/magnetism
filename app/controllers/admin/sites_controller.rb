module Admin
  class SitesController < MagnetismController
    actions :all
    helper_method :theme_collection
    resources_configuration[:self][:route_prefix] = 'admin/manage'
    layout_options :overlay => :new

    def show
      session[:site_id] = resource.id
      redirect_to admin_pages_path
    end

    def theme_collection
      @theme_collection ||= Theme.all
    end
  end
end
