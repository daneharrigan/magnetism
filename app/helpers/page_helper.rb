module PageHelper
  def editable_permalink(page)
    html = page.parent.try(:permalink) || ''.html_safe

    unless page.homepage?
      html = content_tag(:span, html, :id => 'permalink-prefix')
      html << '/' unless page.parent.homepage?
    end

    html << content_tag(:span, page.slug, :id => 'permalink-slug')

    unless page.homepage?
      html << text_field_tag('page[slug]', page.slug)
      html << link_to('Edit', '#edit', :id => 'edit-permalink')
    end

    html
  end
end
