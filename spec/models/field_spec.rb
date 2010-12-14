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

  describe '#input_name' do
    it 'downcases the Field#name value and replaces all spaces with underscores' do
      field = Factory(:field)
      field.input_name.should == field.name.downcase.gsub(/(\s|\-)/,'_'
    end
  end
end
