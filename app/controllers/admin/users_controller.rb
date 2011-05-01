module Admin
  class UsersController < MagnetismController
    before_filter :allow_user?, :only => [:edit, :update]
    actions :all, :except => :index
    layout_options :none => :destroy
    resources_configuration[:self][:route_prefix] = 'admin_manage'

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

      update! { admin_manage_path }
    end

    alias :destroy :render_destroy_js

    private
      def allow_user?
        return true if resource == current_user
        flash[:error] = %{You are not permitted to view that user account}
        redirect_to user_root_path 
      end
  end
end
