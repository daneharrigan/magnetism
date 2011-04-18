module HTMLFilters
  def stylesheet(name)
    %{<link href="/assets/#{Site.current.key}/stylesheets/#{name}.css" media="screen" rel="stylesheet" type="text/css" />}
  end

  def textile(text)
    return if text.blank?
    Magnetism::ContentParser.new(text).invoke
  end

  def date_format(timestamp, format)
    return if timestamp.nil?
    timestamp.strftime(format)
  end

  alias :time_format :date_format

  def link_to(page, link=nil)
    title = page.respond_to?(:title) ? page.title : page
    url = link || page.permalink

    %{<a href="#{url}" title="#{title}">#{title}</a>}
  end

  def read_more(page, title=nil)
    return unless page.excerpt.present? && page.article.present?
    title ||= 'Read more...'
    link_to(title, "#{page.permalink}#read-more")
  end
end
