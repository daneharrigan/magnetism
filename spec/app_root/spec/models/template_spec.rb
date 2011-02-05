require 'spec_helper'

describe Template do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template_type_id) }
  it { should validate_presence_of(:theme_id) }
  it { should validate_numericality_of(:template_type_id) }
  it { should validate_numericality_of(:theme_id) }

  it { should belong_to(:template_type) }
  it { should belong_to(:template_set) }
  it { should belong_to(:theme) }
  it { should have_many(:fields) }
  it { should have_many(:pages) }

  context 'when a template exists' do
    before(:each) { Factory(:template) }
    it { should validate_uniqueness_of(:name).scoped_to(:theme_id, :template_type_id, :template_set_id) }
  end

  describe '.pages' do
    it 'returns all of the templates of type "Template"' do
      template = Factory(:template)
      Template.pages.should == [template]
    end
  end

  describe '.snippets' do
    it 'returns all of the templates of type "Snippet"' do
      template = Factory(:snippet)
      Template.snippets.should == [template]
    end
  end

  describe '.javascripts' do
    it 'returns all of the templates of type "JavaScript"' do
      template = Factory(:javascript)
      Template.javascripts.should == [template]
    end
  end

  describe '.stylesheets' do
    it 'returns all of the templates of type "Stylesheet"' do
      template = Factory(:stylesheet)
      Template.stylesheets.should == [template]
    end
  end

  describe '#destroy?' do
    context 'when the template is part of a template set' do
      it 'returns false' do
        template = Template.new(:template_set => mock_template_set)
        template.destroy?.should == false
      end
    end

    context 'when the template is not part of a template set' do
      it 'returns true' do
        template = Template.new
        template.destroy?.should == true 
      end
    end
  end
end
