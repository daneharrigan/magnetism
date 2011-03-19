require 'spec_helper'

describe Admin::StylesheetsController do
  before(:each) { sign_in Factory(:user) }

  describe '#show' do
    before(:each) do
      @content = 'body { margin: 0; padding: 0; }'
      @content.stub :read => @content
      File.stub :open => @content

      glob = ['path/to/file']
      Dir.stub :glob => glob

      params = { :file_name => 'main', :format => 'css' }
      get :show, params
    end

    it 'returns the value of the stored css file' do
      response.body.should == @content
    end

    it 'sets @file_name to the full path' do
      full_path = "#{Magnetism.root}/app/views/admin/stylesheets/main.*"
      assigns(:full_path).should == full_path
    end
  end
end
