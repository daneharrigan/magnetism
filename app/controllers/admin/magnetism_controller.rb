#require 'layout_options'

module LayoutOptions
  def self.included(controller)
    controller.send(:extend, LayoutOptions::ClassMethods)
    controller.send(:layout, :layout_options_selector)
  end

  def layout_options_selector
    layout_options = LayoutOptions::Storage[controller_name] || {}
    no_layout = layout_options.delete(:none) || []
    no_layout = [no_layout] unless Array === no_layout
    action = action_name.to_sym

    layout_options.each do |key, values|
      values = [values] unless Array === values
      return key.to_s if values.include?(action)
    end

    return no_layout.include?(action) ? false : 'application'
  end

  module ClassMethods
    def layout_options(args={})
      LayoutOptions::Storage[controller_name] = args
    end
  end

  class Storage
    class << self
      def[](key)
        @storage ||= {}
        @storage[key]
      end

      def []=(key, value)
        @storage ||= {}
        @storage[key] = value
      end
    end
  end
end

######################################################

module Admin
  class MagnetismController < InheritedResources::Base
    include Clearance::Authentication
    include ::LayoutOptions

    before_filter :authenticate
    helper_method :current_site
    resources_configuration[:self][:route_prefix] = 'admin'

    # TODO DH: definitely add an around_filter to catch any
    # exceptions raised in an xhr request. maybe also catch
    # catch exceptions raised in regular requests too.
    #
    # this would need two different view templates.

    def current_site
      @current_site ||= session[:site_id] ? Site.find(session[:site_id]) : Site.first
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
  end
end
