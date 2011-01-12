module PageHelper
  def editable_permalink(page)
    return content_tag(:span, page.permalink, :id => 'permalink-prefix') if page.homepage?

    <<-HTML
      #{content_tag(:span, page.parent.permalink, :id => 'permalink-prefix')}
      #{content_tag(:span, page.slug, :id => 'permalink-slug')}
      #{text_field_tag('page[slug]', page.slug)}
    HTML
  end
end
