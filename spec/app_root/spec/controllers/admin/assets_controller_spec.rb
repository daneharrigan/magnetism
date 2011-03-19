require 'spec_helper'

describe Admin::AssetsController do
  describe '#show' do
    context 'when an existing javascript file is requested' do
      it 'returns the contents of the file' do
        params = { :file_name => 'application', :format => 'js' }
        get :show, params
      end
    end

    context 'when an existing css file is requested' do
      it 'returns the contents of the file'
    end

    context 'when an existing scss file is requested' do
      it 'returns the generated css'
    end

    context 'when a file is requested that does not exist' do
      it 'returns a 404 error'
    end
  end
end
