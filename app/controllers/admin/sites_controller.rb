module Admin
  class SitesController < MagnetismController
    actions :all
    resources_configuration[:self][:route_prefix] = 'admin/manage'

    def show
      session[:site_id] = resource.id
      redirect_to admin_pages_path
    end
  end
end
