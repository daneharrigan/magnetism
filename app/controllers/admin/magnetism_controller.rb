module Admin
  class MagnetismController < InheritedResources::Base
    include LayoutOptions
    helper :magnetism
    helper_method :current_site

    before_filter :authenticate_user!
    resources_configuration[:self][:route_prefix] = 'admin'

    # TODO DH: definitely add an around_filter to catch any
    # exceptions raised in an xhr request. maybe also catch
    # catch exceptions raised in regular requests too.
    #
    # this would need two different view templates.

    # NOTE DH: I feel like this needs to be protected or private, but
    # because I'm aliasing the show method to it, it shouldn't
    def redirect_to_edit
      redirect_to edit_polymorphic_path([:admin, resource])
    end

    def render_destroy_js
      resource.destroy
    end

    def current_site
      @current_site ||= session[:site_id] ? Site.find(session[:site_id]) : Site.first
    end
  end
end
