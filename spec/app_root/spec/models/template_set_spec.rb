require 'spec_helper'

describe TemplateSet do
  it { should validate_presence_of(:name) }
  it { should have_many(:templates) }
  it { should have_many(:pages) }
  it { should belong_to(:theme) }

  context 'when a template set exists' do
    before(:each) { Factory(:template_set) }
    it { should validate_uniqueness_of(:name) }
  end
end
