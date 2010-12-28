module Admin
  class UsersController < MagnetismController
    actions :all, :except => :index

    def index
      redirect_to admin_manage_path
    end
  end
end
