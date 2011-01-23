require 'spec_helper'

describe Theme do
  it { should validate_presence_of(:name) }
  it { should have_many(:sites) }
  it { should have_many(:templates) }

  context 'when a theme exists' do
    before(:each) { Factory(:theme) }
    it { should validate_uniqueness_of(:name) }
  end
end
