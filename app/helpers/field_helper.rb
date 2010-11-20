module FieldHelper
  def field_tag(field, display_type = nil)
    tag_name = case field.field_type
      when FieldType.text_field
        :input
      when FieldType.large_text_field
        :textarea
    end

    content_tag(display_type, nil, :class => tag_name)
  end

  def field_class(field)
    return 'textarea' if field.field_type == FieldType.large_text_field
  end
end
