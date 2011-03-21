module Admin
  class ThemesController < MagnetismController
    actions :all
    layout_options :overlay => [:new, :edit], :none => :update
    resources_configuration[:self][:route_prefix] = 'admin/manage'
    helper :theme

    def update
      update! do |success, failure|
        success.html { redirect_to admin_manage_path }
      end
    end

    alias :destroy :render_destroy_js
  end
end
