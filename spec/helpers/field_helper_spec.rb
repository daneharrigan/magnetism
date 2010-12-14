require 'spec_helper'

describe FieldHelper do
  describe '#field_tag' do
    context 'when passed a display type of :span' do
      it 'should return a span with the class input' do
        field = Factory(:field, :field_type => Factory(:field_type_text_field))
        field_tag(field, :span).should == %{<span class="input"></span>}
      end
      it 'should return a span with the class textarea' do
        field = Factory(:field, :field_type => Factory(:field_type_large_text_field))
        field_tag(field, :span).should == %{<span class="textarea"></span>}
      end
    end

    context 'when returning a form field' do
      before(:each) do
        @page = Factory(:page)
        @page.current!
      end

      it 'should return a text input' do
        field = Factory(:field_with_text_field)
        entry = Factory(:string_datum)
        field.data.create(:page => @page, :entry => entry)
        @page.template.fields << field

        name = "page[field][#{field.input_name}]"
        id = "page_field_#{field.input_name}"

        helper.field_tag(field).should == %{<input id="#{id}" name="#{name}" type="text" value="#{field.value}" />}
      end

      it 'should return a textarea' do
        field = Factory(:field_with_large_text_field)
        entry = Factory(:text_datum)
        field.data.create(:page => @page, :entry => entry)
        @page.template.fields << field

        name = "page[field][#{field.input_name}]"
        id = "page_field_#{field.input_name}"

        helper.field_tag(field).should == %{<textarea id="#{id}" name="#{name}">#{field.value}</textarea>}
      end
    end
  end

  describe '#field_class' do
    context 'when the field_type is "Large text field"' do
      it 'returns textarea' do
        field = Factory(:field, :field_type => Factory(:field_type_large_text_field))
        field_class(field).should == 'textarea'
      end
    end
  end
end
