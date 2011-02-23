module PageHelper
  def editable_permalink(page)
    slug = content_tag(:span, page.slug, :id => 'permalink-slug')
    return slug if page.homepage?

    prefix = page.permalink.sub(/#{page.slug}$/,'')
    prefix = content_tag(:span, prefix, :id => 'permalink-prefix')

    html = prefix + slug + text_field_tag('page[slug]', page.slug)
    html << link_to('Edit', '#edit', :id => 'edit-permalink')
  end

  def parent_page
    @parent_page ||= current_site.pages.find(params[:parent_id]) if params[:parent_id]
  end

  def template_collection
    @template_collection ||= current_site.theme.templates.pages
  end

  def template_set_collection
    @template_set_collection ||= current_site.theme.template_sets
  end

  def row_class(page)
    return 'item' if page.homepage?
    cycle('item','item alt')
  end
end
