require 'spec_helper'

describe Admin::JavascriptsController do
  before(:each) { sign_in Factory(:user) }

  describe '#show' do
    before(:each) do
      @content = '$(function(){ /* javascript */ });'
      @content.stub :read => @content
      File.stub :open => @content

      glob = ['path/to/file']
      Dir.stub :glob => glob

      params = { :file_name => 'main', :format => 'js' }
      get :show, params
    end

    it 'returns the value of the stored css file' do
      response.body.should == @content
    end

    it 'sets @file_name to the full path' do
      full_path = "#{Magnetism.root}/app/views/admin/javascripts/main.*"
      assigns(:full_path).should == full_path
    end

    context 'when a file can not be found' do
      before(:each) do
        glob = []
        Dir.stub :glob => glob

        params = { :file_name => 'main', :format => 'js' }
        get :show, params
      end

      it 'renders nothing' do
        response.body.should be_blank
      end

      it 'returns a 404 status' do
        response.status.should == 404
      end
    end
  end
end
