require 'spec_helper'

describe PageHelper do
  describe '#editable_permalink' do
    let(:site) { Factory.build(:site) }

    context 'when the page has a parent' do
      before(:each) do
        @parent = Factory.build(:page, :slug => 'section', :site => site)
        @page = Factory.build(:page, :slug => 'subection', :parent => @parent, :site => @parent.site)
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
      before(:each) do
        @page = Factory.build(:homepage, :slug => '/', :site => site)
        @page.site.stub :homepage => @page
        @html = helper.editable_permalink(@page)
      end

      it 'returns the domain' do
        @html.should have_selector('span#permalink-slug', :content => @page.permalink)
      end

      it 'does not have a permalink prefix' do
        @html.should_not have_selector('span#permalink-prefix')
      end
    end
  end

  describe '#parent_page' do
    it 'returns the page whose id matches parent_id' do
      current_site = mock_site
      parent_page = mock_page
      pages = [parent_page]

      pages.stub :find => parent_page
      current_site.stub :pages => pages

      helper.stub :current_site => current_site
      helper.stub :params => { :parent_id => parent_page.id }
      helper.parent_page.should == parent_page
    end
  end

  describe '#template_collection' do
    it 'returns all of the page templates in the theme of the current site' do
      current_site = mock_site
      theme = mock_theme
      template = mock_template
      templates = [template]

      templates.stub :pages => templates
      theme.stub :templates => templates
      current_site.stub :theme => theme

      helper.stub :current_site => current_site
      helper.template_collection.should == templates
    end
  end

  describe '#template_set_collection' do
    it 'returns all of the template sets in the theme of the current site' do
      current_site = mock_site
      theme = mock_theme
      template_set = mock_template_set
      template_sets = [template_set]

      theme.stub :template_sets => template_sets
      current_site.stub :theme => theme

      helper.stub :current_site => current_site
      helper.template_set_collection.should == template_sets
    end
  end

  describe '#row_class' do
    context 'when the page is the homepage' do
      it 'returns item' do
        page = mock_page(:homepage? => true)
        helper.row_class(page).should == 'item'
      end
    end

    context 'when the page is not the homepage' do
      before(:each) do
        page_1 = mock_page(:homepage? => false)
        page_2 = mock_page(:homepage? => false)
        @output = [row_class(page_1), row_class(page_2)]
      end

      it 'returns "item" for all odd page rows' do
        @output.first.should == 'item'
      end

      it 'returns "item alt" for all even page rows' do
        @output.second.should == 'item alt'
      end
    end
  end
end
