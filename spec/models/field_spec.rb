require 'spec_helper'

describe Field do
  it { should belong_to(:template) }
  it { should belong_to(:field_type) }
  it { should have_many(:data) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template_id) }
  it { should validate_presence_of(:field_type_id) }

  context 'when a field exists' do
    before(:each) { Factory(:field) }
    it { should validate_uniqueness_of(:name).scoped_to(:template_id) }
  end

  describe '.[]' do
    it 'returns the field value that matches the key' do
      page = Factory(:page)
      field = Factory(:field)
      page.template.fields << field
      page.current!

      Field[field.input_name].should == field.value
    end
  end

  describe '#auto_position' do
    let(:template) { Factory(:field).template }

    it 'sets the position attribute to the total number of fields for that template' do
      field = Factory(:field, :template => template)
      field.position.should == template.fields.count
    end
  end

  describe '#value' do
    it 'returns the value of the entry, scoped to the page' do
      page = Factory(:page)
      field = Factory(:field)
      entry = Factory(:string_datum)

      page.template.fields << field
      field.data.create(:page => page, :entry => entry)

      page.current!
      field.value.should == entry.value
    end
  end

  describe '#value=' do
    before(:each) do
      @page = Factory(:page)
      @page.current!
    end

    context 'when a value is set for a field that does not have a value' do
      it 'creates a new entry in the string_data table' do
        field = Factory(:field_with_text_field)
        @page.template.fields << field

        lambda { field.value = 'John Doe' }.should change(StringDatum, :count).by(+1)
      end

      it 'creates a new entry in the text_data table' do
        field = Factory(:field_with_large_text_field)
        @page.template.fields << field

        lambda { field.value = 'Lorem Ipsum' }.should change(TextDatum, :count).by(+1)
      end

      it 'creates a new entry in the datetime_data table'
      it 'creates a new entry in the boolean_data table'
    end

    context 'when a value is sent for a field that already has a value' do
      it 'replaces the value in the string_data table' do
        field = Factory(:field_with_text_field)
        @page.template.fields << field
        field.value = 'Initial Value'
        field.value = 'Overwritten Value'

        field.value.should == 'Overwritten Value'
      end

      it 'replaces the value in the text_data table' do
        field = Factory(:field_with_large_text_field, :template => @page.template)
        field.value = 'Initial Value'
        field.value = 'Overwritten Value'

        field.value.should == 'Overwritten Value'
      end

      it 'replaces the value in the datetime_data table'
      it 'replaces the value in the boolean_data table'
    end
  end

  describe '#input_name' do
    it 'downcases the Field#name value and replaces all spaces with underscores' do
      field = Factory(:field)
      field.input_name.should == field.name.downcase.gsub(/(\s|\-)/,'_')
    end
  end
end
