require 'spec_helper'

describe TemplateHelper do
  describe '#template_type' do
    it 'returns the template type passed in the params' do
      template_type = Factory(:template_type)
      helper.stub :params => { :template_type_id => template_type.id }

      helper.template_type.should == template_type
    end
  end

  describe '#page_template?' do
    it 'returns true when the resource has the template type of Page' do
      helper.stub :resource => Factory(:template)
      helper.page_template?.should == true
    end
  end
end
