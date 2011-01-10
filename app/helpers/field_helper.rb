module FieldHelper
  def field_tag(field, display_type = nil)
    tag_name = case field.field_type
      when FieldType.text_field
        :input
      when FieldType.large_text_field
        :textarea
      when FieldType.asset
        :asset
    end

    display_type ? span_tag(field, tag_name) : input_tag(field, tag_name)
  end

  def field_class(field)
    return 'textarea' if field.field_type == FieldType.large_text_field
  end

  private
    def span_tag(field, tag_name)
      content_tag(:span, nil, :class => tag_name)
    end

    def input_tag(field, tag_name)
      name = "page[fields][#{field.input_name}]"
      case tag_name
        when :input
          text_field_tag(name, field.value)
        when :textarea
          text_area_tag(name, field.value)
        when :asset
          file_field_tag(name)
      end
    end
end
