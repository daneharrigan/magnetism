require 'spec_helper'

describe Site do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:domain) }
  it { should validate_numericality_of(:theme_id) }

  it { should allow_value(true).for(:production) }
  it { should allow_value(false).for(:production) }

  it { should have_many(:pages) }

  it { should belong_to(:homepage) }
  it { should belong_to(:theme) }

  describe '.current' do
    context 'when #current! is not triggered' do
      it 'returns nil' do
        pending 'might not be necessary'
        Site.current.should be_nil
      end

      it 'returns a site' do
        pending 'might not be necessary'
        site = Factory(:site)
        site.current!

        Site.current.should == site
      end
    end
  end

  context 'when a site exists' do
    before(:each) { Factory(:site) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:domain) }
  end

  # it { should have_many(:redirects) }  
end
