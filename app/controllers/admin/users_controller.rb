module Admin
  class UsersController < MagnetismController
    actions :all, :except => :index
    layout_options :overlay => :new
    resources_configuration[:self][:route_prefix] = 'admin/manage'

    def index
      redirect_to admin_manage_path
    end
  end
end
