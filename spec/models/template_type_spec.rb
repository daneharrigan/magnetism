require 'spec_helper'

describe TemplateType do
  it { should validate_presence_of(:name) }

  context 'when a template type exists' do
    before(:each) { Factory(:template_type) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '.template' do
    it 'returns the "Template" template type' do
      Factory(:template_type_page) # can be read as Template Type: Page
      template_type = TemplateType.first(:conditions => { :name => 'Page' })
      TemplateType.page.should === template_type
    end
  end

  describe '.snippet' do
    it 'returns the "Snippet" template type' do
      Factory(:template_type_snippet) # can be read as Template Type: Snippet
      template_type = TemplateType.first(:conditions => { :name => 'Snippet' })
      TemplateType.snippet.should === template_type
    end
  end

  describe '.javascript' do
    it 'returns the "JavaScript" template type' do
      Factory(:template_type_javascript) # can be read as Template Type: JavaScript
      template_type = TemplateType.first(:conditions => { :name => 'JavaScript' })
      TemplateType.javascript.should === template_type
    end
  end

  describe '.stylesheet' do
    it 'returns the "Stylesheet" template type' do
      Factory(:template_type_stylesheet) # can be read as Template Type: Stylesheet
      template_type = TemplateType.first(:conditions => { :name => 'Stylesheet' })
      TemplateType.stylesheet.should === template_type
    end
  end
end
