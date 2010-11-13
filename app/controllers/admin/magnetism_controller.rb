module Admin
  class MagnetismController < InheritedResources::Base
    include Clearance::Authentication

    before_filter :authenticate
    helper_method :current_site
    layout :layout_selector

    # TODO DH: definitely add an around_filter to catch any
    # exceptions raised in an xhr request. maybe also catch
    # catch exceptions raised in regular requests too.
    #
    # this would need two different view templates.

    def current_site
      @_current_site ||= session[:site_id] ? Site.find(session[:site_id]) : Site.first
    end

    # NOTE DH: I feel like this needs to be protected or private, but
    # because I'm aliasing the show method to it, it shouldn't
    def redirect_to_edit
      redirect_to edit_polymorphic_path([:admin, resource])
    end

    def render_destroy_js
      resource.destroy
    end

    private
      def deny_access(flash_message = nil)
        store_location
        flash[:failure] = flash_message if flash_message
        redirect_to new_admin_session_path
      end

      def layout_selector
        action = params[:action].to_sym
        @@_layout_options ||= {}
        no_layout = @@_layout_options.delete(:none) || {}

        @@_layout_options.each do |layout, actions|
          actions = [actions] unless Array === actions
          return layout.to_s if actions.include? action
        end

        no_layout = [no_layout] unless Array == no_layout
        no_layout.include?(action) ? false : 'application'
      end

      def self.layout_options(args={})
        @@_layout_options = args
      end
  end
end