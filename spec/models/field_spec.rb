require 'spec_helper'

describe Field do
  it { should belong_to(:template) }
  # it { should belong_to(:field_type) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template_id) }
  # it { should validate_presence_of(:field_type_id) }

  context 'when a field exists' do
    before(:each) { Factory(:field) }
    it { should validate_uniqueness_of(:name).scoped_to(:template_id) }
  end
end
