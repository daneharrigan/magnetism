require 'spec_helper'

describe Admin::SupportFilesController do
  before(:each) { sign_in Factory(:user) }

  describe '#show' do
    before(:each) do
      @content = 'body { margin: 0; padding: 0; }'
      @content.stub :read => @content
      File.stub :open => @content

      glob = ['path/to/file']
      Dir.stub :glob => glob

      params = { :file_name => 'main', :format => 'css', :directory => 'stylesheets' }
      get :show, params
    end

    it 'returns the value of the stored css file' do
      response.body.should == @content
    end

    it 'sets @file_name to the full path' do
      full_path = "#{Magnetism.root}/app/views/admin/support_files/stylesheets/main.*"
      assigns(:full_path).should == full_path
    end

    context 'when a file can not be found' do
      before(:each) do
        glob = []
        Dir.stub :glob => glob

        params = { :file_name => 'main', :format => 'css', :directory => 'stylesheets' }
        get :show, params
      end

      it 'renders nothing' do
        response.body.should be_blank
      end

      it 'returns a 404 status' do
        response.status.should == 404
      end
    end

    context 'when an incorrect file extension is used' do
      before(:each) do
        glob = ['path/to/file']
        Dir.stub :glob => glob

        params = { :file_name => 'main', :format => 'doesntexist', :directory => 'stylesheets' }
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
