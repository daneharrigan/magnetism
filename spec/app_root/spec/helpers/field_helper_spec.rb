require 'spec_helper'

describe FieldHelper do
  describe '#field_tag' do
    context 'when passed a display type of :span' do
      it 'should return a span with the class input' do
        field = Factory.build(:field, :field_type => Factory(:field_type_text_field))
        field_tag(field, :span).should have_selector('span', :class => 'input')
      end

      it 'should return a span with the class textarea' do
        field = Factory.build(:field, :field_type => Factory(:field_type_large_text_field))
        field_tag(field, :span).should have_selector('span', :class => 'textarea')
      end

      it 'should return a span with the class asset' do
        field = Factory.build(:field, :field_type => Factory(:field_type_asset))
        field_tag(field, :span).should have_selector('span', :class => 'asset')
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
        @page.data.create(:entry => entry, :field_name => field.name)
        @page.template.fields << field

        name = "page[fields][#{field.input_name}]"
        id = "page_fields_#{field.input_name}"

        helper.field_tag(field).should have_selector('input', :id => id, :name => name, :type => 'text', :value => field.value)
      end

      it 'should return a textarea' do
        field = Factory(:field_with_large_text_field)
        entry = Factory(:text_datum)
        @page.data.create(:entry => entry, :field_name => field.name)
        @page.template.fields << field

        name = "page[fields][#{field.input_name}]"
        id = "page_fields_#{field.input_name}"

        helper.field_tag(field).should have_selector('textarea', :id => id, :name => name, :content => field.value)
      end

      it 'should return an asset uploader field' do
        field = Factory.build(:field, :field_type => Factory(:field_type_text_field))
        name = "page[fields][#{field.input_name}]"
        id = "page_fields_#{field.input_name}"

        helper.field_tag(field).should have_selector('input', :id => id, :name => name)
      end
    end
  end

  describe '#field_class' do
    context 'when the field_type is "Large text field"' do
      it 'returns textarea' do
        field = Factory.build(:field, :field_type => Factory(:field_type_large_text_field))
        field_class(field).should == 'textarea'
      end
    end
  end
end
