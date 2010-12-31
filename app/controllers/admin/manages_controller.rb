module Admin
  class ManagesController < MagnetismController
    helper_method :site_collection, :theme_collection, :user_collection

    def show; end

    protected
      def site_collection
        @site_collection ||= Site.all
      end

      def theme_collection
        @theme_collection ||= Theme.all
      end

      def user_collection
        @user_collection ||= User.all
      end
  end
end
