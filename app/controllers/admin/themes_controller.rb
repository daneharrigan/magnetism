module Admin
  class ThemesController < MagnetismController
    actions :all
    layout_options :overlay => [:new, :edit]
    helper_method :template_collection, :snippet_collection,
      :stylesheet_collection, :javascript_collection
    resources_configuration[:self][:route_prefix] = 'admin/manage'

    def template_collection
      @template_collection ||= Template.templates
    end

    def snippet_collection
      @snippet_collection ||= Template.snippets
    end

    def javascript_collection
      @javascript_collection ||= Template.javascripts
    end

    def stylesheet_collection
      @stylesheet_collection ||= Template.stylesheets
    end
  end
end
