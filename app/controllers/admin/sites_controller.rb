module Admin
  class SitesController < MagnetismController
    actions :all
    helper_method :theme_collection
    resources_configuration[:self][:route_prefix] = 'admin/manage'
    layout_options :overlay => [:new, :edit]

    def show
      session[:site_id] = resource.id
      redirect_to admin_pages_path
    end

    def create
      create! do |success, failure|
        success.html do
          flash[:success] = t('magnetism.success.site')
          redirect_to admin_manage_site_path(resource)
        end

        failure.html do
          flash[:alert] = t('magnetism.failure.site')
          redirect_to admin_manage_path
        end
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to admin_manage_path }
      end
    end

    alias :destroy :render_destroy_js

    private
      def theme_collection
        @theme_collection ||= Theme.all
      end
  end
end
