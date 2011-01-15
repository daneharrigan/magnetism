class SnippetTag < Liquid::Tag
  def render(context)
    name = @markup.gsub(/(:\s|\'|\"|\s+$)/,'')
    snippets = Site.current.theme.templates.snippets
    template = snippets.first(:conditions => { :name => name })
    Liquify.render(template.content)
  end
end
