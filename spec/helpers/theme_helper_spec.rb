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
      helper.template_collection.should == [template]
    end
  end

  describe '#new_template_collection' do
    it 'returns an array of links to create new templates' do
      Factory(:template_type_template)
      Factory(:template_type_snippet)
      Factory(:template_type_javascript)
      Factory(:template_type_stylesheet)
      theme = Factory(:theme)

      helper.stub :resource => theme

      helper.new_template_collection.each_with_index do |link, index|
        template_type = TemplateType.all[index]
        link.should have_selector('a',
          :href => new_admin_manage_theme_template_path(theme, :template_type_id => template_type.id),
          :content => template_type.name)
      end
    end
  end
end
