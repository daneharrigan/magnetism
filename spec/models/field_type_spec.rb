require 'spec_helper'

describe FieldType do
  it { should validate_presence_of(:name) }
  it { should have_many(:fields) }

  context 'when a field type exists' do
    before(:each) { Factory(:field_type) }
    it { should validate_uniqueness_of(:name) }
  end
end
