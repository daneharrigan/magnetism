require 'spec_helper'

describe PageHelper do
  describe '#editable_permalink' do
    context 'when the page has a parent' do
      before(:each) do
        @parent = Factory(:page)
        @page = Factory(:page, :parent => @parent, :site => @parent.site)
        @html = helper.editable_permalink(@page)
      end

      it 'returns the domain and the parent permalink' do
        @html.should have_selector('span#permalink-prefix', :content => @parent.permalink)
      end

      it 'returns the page slug' do
        @html.should have_selector('span#permalink-slug', :content => @page.slug)
      end

      it 'returns a text field with the page slug' do
        @html.should have_selector('input', :name => 'page[slug]', :value => @page.slug)
      end
    end

    context 'when the page is the homepage' do
      it 'returns the domain' do
        page = Factory(:page)
        page.site.stub :homepage => page
        html = helper.editable_permalink(page)

        html.should have_selector('span#permalink-prefix', :content => page.permalink)
      end
    end
  end
end
