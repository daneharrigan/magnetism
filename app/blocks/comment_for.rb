class CommentFor < Liquify::Block
  def invoke(params)
    attributes = params.extract_options!
    page = params.first

    return unless page['blog_entry?']

    if page['close_comments?']
      return <<-STR
        <div id="closed-comments">
          <p>Comments have been closed.<p>
        </div>
      STR
    end

    attributes['action'] = "#{page.permalink}/comments"
    attributes['method'] = 'post'
    attributes.delete 'as'

    %{<form #{build_attributes(attributes)}>
        #{yield}
      </form>}
  end

  def author_name(params)
    input_tag(:author_name, params)
  end

  def author_email(params)
    input_tag(:author_email, params)
  end

  def author_url(params)
    input_tag(:author_url, params)
  end

  def body(params)
      attributes = params.extract_options!
      attributes['name'] = "comment[body]"
      value = attributes.delete 'value'

    "<textarea #{build_attributes(attributes)}>#{value}</textarea>"
  end

  def submit(params)
    attributes = params.extract_options!
    attributes['type'] = 'submit'
    attributes['value'] ||= 'Submit'
    params << attributes

    input_tag(:submit, params)
  end

  private
    def input_tag(field_name, params)
      attributes = params.extract_options!
      attributes['type'] ||= 'text'
      attributes['name'] = "comment[#{field_name}]"

      "<input #{build_attributes(attributes)} />"
    end

    def build_attributes(attributes)
      attributes.map { |key,value| %{#{key}="#{value}"} }.join(' ')
    end
end
