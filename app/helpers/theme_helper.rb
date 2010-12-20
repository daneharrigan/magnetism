# TODO: Revisit view and controller code to determine if these methods are only
#       being called once. If they're only called once we dont need to do the ||=
module ThemeHelper
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

  def new_template_collection
    @new_template_collection ||= TemplateType.all.map do |template_type|
      link_to( template_type.name, new_polymorphic_path([:admin, :manage, resource, :template], :template_type_id => template_type.id) )
    end
  end
end
