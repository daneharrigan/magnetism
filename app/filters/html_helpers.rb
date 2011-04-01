module HTMLHelpers
  def stylesheet(name)
    %{<link href="/assets/#{Site.current.key}/stylesheets/#{name}.css" media="screen" rel="stylesheet" type="text/css" />}
  end

  def textile(text)
    return if text.blank?
    RedCloth.new(text).to_html
  end

  def date_format(timestamp, format)
    timestamp.strftime(format)
  end

  alias :time_format :date_format
end
