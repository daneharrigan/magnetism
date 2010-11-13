module Admin
  class ManagesController < MagnetismController
    helper_method :site_collection, :theme_collection

    def show; end

    protected
      def site_collection
        @_site_collection ||= Site.all
      end

      def theme_collection
        @_theme_collection ||= Theme.all
      end
  end
end