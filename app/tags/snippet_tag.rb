class SnippetTag < Liquify::Tag
  def invoke(params)
    options = params.extract_options!
    snippets = Site.current.theme.templates.snippets
    template = snippets.first(:conditions => { :name => params.first })

    return Liquify.invoke(template.content, :first => true, :last => true) unless options['collection']

    collection = find_collection(options)

    collection.map do |item|
      extra_context = { :first => (collection.first == item), :last => (collection.last == item) }
      key = options['as'] || 'item'
      extra_context[key] = item

      Liquify.invoke(template.content, extra_context)
    end.join("\n")
  end

  private
    def find_collection(options)
      starting_point = case
        when options['parent_uri']
          Site.current.pages.find_by_path(options['parent_uri'])
        end

      return [] if starting_point.nil?
      starting_point.to_liquid[options['collection']] || []
    end
end
