require 'spec_helper'

describe MagnetismHelper do
  describe '#site_selector_collection' do
    before(:each) { Factory(:site) }
    it 'returns an array of all of the sites' do
      Site.all.each_with_index do |site, i|
        helper.site_selector_collection[i].should have_selector('a',
          :href => admin_manage_site_path(site),
          :content => site.name)
      end
    end

    it 'contains a link to make a new site' do
      site_selector_collection.last.should have_selector('a',
        :href => new_admin_manage_site_path,
        :content => 'New Site')
    end
  end
end
