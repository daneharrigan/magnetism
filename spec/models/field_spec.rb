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
      field = Factory(:field)
      debugger
      ""
    end
  end
end
