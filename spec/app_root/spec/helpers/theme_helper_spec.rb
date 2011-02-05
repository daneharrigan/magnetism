require 'spec_helper'

describe ThemeHelper do
  describe '#snippet_collection' do
    it 'returns all of the templates of type "Snippet"' do
      template = Factory(:snippet)
      helper.snippet_collection.should == [template]
    end
  end

  describe '#javascript_collection' do
    it 'returns all of the templates of type "JavaScript"' do
      template = Factory(:javascript)
      helper.javascript_collection.should == [template]
    end
  end

  describe '#stylesheet_collection' do
    it 'returns all of the templates of type "Stylesheet"' do
      template = Factory(:stylesheet)
      helper.stylesheet_collection.should == [template]
    end
  end

  describe '#template_collection' do
    it 'returns all of the templates of type "Template"' do
      template = Factory(:template)
      helper.page_collection.should == [template]
    end
  end

  describe '#blog_collection' do
    it 'returns all of the "template sets"' do
      template_set = Factory(:template_set)
      helper.blog_collection.should == [template_set]
    end
  end

  describe '#new_template_collection' do
    before(:each) do
      Factory(:template_type_page)
      Factory(:template_type_snippet)
      Factory(:template_type_javascript)
      Factory(:template_type_stylesheet)
      @theme = mock_model(Theme) #Factory.build(:theme)

      helper.stub :resource => @theme
    end

    it 'returns an array of links to create new templates' do
      TemplateType.all.each_with_index do |template_type, index|
        link = helper.new_template_collection[index]

        link.should have_selector('a',
          :href => new_admin_manage_theme_template_path(@theme, :template_type_id => template_type.id),
          :content => template_type.name)
      end
    end

    it 'returns a final link to create a blog template set' do
      link = helper.new_template_collection.last

      link.should have_selector('a',
        :href => new_admin_manage_theme_template_set_path(@theme), :content => 'Blog')
    end
  end
end
