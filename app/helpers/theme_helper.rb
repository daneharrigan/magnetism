# TODO: Revisit view and controller code to determine if these methods are only
#       being called once. If they're only called once we dont need to do the ||=
module ThemeHelper
  def page_collection
    @page_collection ||= Template.pages
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

  def blog_collection
    @blog_collection ||= TemplateSet.all
  end

  def new_template_collection
    @new_template_collection ||= TemplateType.all.map do |template_type|
      collection = [:admin, :manage, resource, :template]
      url = new_polymorphic_path(collection, :template_type_id => template_type.id)
      link_to template_type.name, url, :remote => true, 'data-type' => :html
    end << link_to( 'Blog', new_polymorphic_path([:admin, :manage, resource, :template_set]),
             :remote => true, 'data-type' => :html )
  end
end
