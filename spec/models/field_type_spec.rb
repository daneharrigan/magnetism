require 'spec_helper'

describe FieldType do
  it { should validate_presence_of(:name) }
  it { should have_many(:fields) }

  context 'when a field type exists' do
    before(:each) { Factory(:field_type) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '.text_field' do
    it 'returns the "Text field" field type' do
      field_type = Factory(:field_type_text_field)
      FieldType.text_field.should == field_type
    end
  end

  describe '.large_text_field' do
    it 'returns the "Large text field" field type' do
      field_type = Factory(:field_type_large_text_field)
      FieldType.large_text_field.should == field_type
    end
  end
end
