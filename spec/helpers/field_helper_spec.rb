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
      it 'should return a text input'do
        field = Factory(:field_with_data, :field_type => Factory(:field_type_text_field))
        field_tag(field).should == %{<input name="" value="" type="text" id="" />}
      end

      it 'should return a textarea' do
        field = Factory(:field_with_data, :field_type => Factory(:field_type_large_text_field))
        field_tag(field).should == %{<textarea name="" value="" id=""></textarea>}
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
