module Admin
  class ThemesController < MagnetismController
    actions :all
    layout_options :overlay => [:new, :edit], :none => :update
    resources_configuration[:self][:route_prefix] = 'admin/manage'

    def update
      update! do |success, failure|
        success.html { redirect_to admin_manage_path }
      end
    end
  end
end
