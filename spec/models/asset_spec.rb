require 'spec_helper'
require 'carrierwave/test/matchers'

describe Asset do
  include CarrierWave::Test::Matchers

  it { should belong_to(:site) }
  it { should validate_presence_of(:site_id) }

  describe '#file' do
    before(:each) do
      file = File.open(support_image_path('carrierwave/fpo.gif'))

      site = Factory(:site)
      site.current!

      @asset = Factory(:asset, :site => site, :file => file)
    end

    after(:each) { Site.clear_current! }

    it 'made a thumbnail with the dimensions of 100x100' do
      @asset.file.thumbnail.should have_dimensions(100, 100)
    end

    it 'has permissions of 666' do
      @asset.file.should have_permissions(0666)
    end
  end
end
