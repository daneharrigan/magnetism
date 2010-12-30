require 'spec_helper'

describe DispatchController do
  context 'when a page exists' do
    it 'outputs the rendered liquid template' do
      template = mock_model(Template, :content => '{{ page.title }}')
      page = mock_model(Page,
        :template => template,
        :current! => true,
        :to_liquid => { 'title' => 'Foo Title' })

      Page.stub :find_by_path => page, :current => page
      request.request_uri = '/'

      get :show
      response.body.should == 'Foo Title'
    end
  end

  context 'when a page does not exist' do
    before(:each) do
      Page.stub :find_by_path => nil
      get :show
    end

    it 'returns a status of 404' do
      response.status.should == 404
    end

    it 'returns the 404 page' do
      debugger
      response.body.should_not be_empty
    end
  end
end
