class SnippetTag < Liquify::Tag
  def invoke(params)
    snippets = Site.current.theme.templates.snippets
    template = snippets.first(:conditions => { :name => params.first })
    Liquify.render(template.content)
  end
end
