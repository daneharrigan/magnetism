module HTMLFilters
  def stylesheet(name)
    %{<link href="/assets/#{Site.current.key}/stylesheets/#{name}.css" media="screen" rel="stylesheet" type="text/css" />}
  end

  def textile(text)
    return if text.blank?
    Magnetism::ContentParser.new(text)
  end

  def date_format(timestamp, format)
    timestamp.strftime(format)
  end

  alias :time_format :date_format

  def link_to(page)
    %{<a href="#{page.permalink}" title="#{page.title}">#{page.title}</a>}
  end
end
