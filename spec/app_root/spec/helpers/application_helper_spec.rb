require 'spec_helper'

describe ApplicationHelper do
  describe '#section_stylesheet_link_tag' do
    context 'when a file exists' do
      it 'returns the link tag to that file' do
        File.stub(:exists? => true)
        name = 'controller-name'
        controller.stub(:controller_name => name)

        tag = %{<link href="/admin/stylesheets/#{name}.css" media="screen" rel="stylesheet" type="text/css" />}
        section_stylesheet_link_tag.should == tag
      end
    end

    context 'when the file does not exist' do
      it 'returns nothing' do
        File.stub(:exists? => false)
        section_stylesheet_link_tag.should be_nil
      end
    end
  end

  describe '#section_javascript_include_tag' do
    context 'when a file exists' do
      it 'returns the script tag to that file' do
        File.stub(:exists? => true)
        name = 'controller-name'
        controller.stub(:controller_name => name)

        tag = %{<script src="/admin/javascripts/#{name}.js" type="text/javascript"></script>}
        section_javascript_include_tag.should == tag
      end
    end

    context 'when the file does not exist' do
      it 'returns nothing' do
        File.stub(:exists? => false)
        section_javascript_include_tag.should be_nil
      end
    end
  end
end
