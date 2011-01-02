module Admin
  class UsersController < MagnetismController
    actions :all, :except => :index
    layout_options :overlay => [:new, :edit], :none => :destroy
    resources_configuration[:self][:route_prefix] = 'admin/manage'

    def index
      redirect_to admin_manage_path
    end

    def create
      create! do |success, failure|
        success.html { redirect_to admin_manage_path }
      end
    end

    def update
      [:password, :password_confirmation].each do |key|
        params[:user].delete(key) if params[:user][key].empty?
      end

      update! do |success, failure|
        success.html { redirect_to admin_manage_path }
      end
    end

    alias :destroy :render_destroy_js
  end
end
