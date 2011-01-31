module PageHelper
  def editable_permalink(page)
    slug = content_tag(:span, page.slug, :id => 'permalink-slug')
    return slug if page.homepage?

    prefix = page.permalink.sub(/#{page.slug}$/,'')
    prefix = content_tag(:span, prefix, :id => 'permalink-prefix')

    html = prefix + slug + text_field_tag('page[slug]', page.slug)
    html << link_to('Edit', '#edit', :id => 'edit-permalink')
  end
end
