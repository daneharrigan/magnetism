require 'spec_helper'

describe DispatchController do
  context 'when a page exists' do
    it 'outputs the rendered liquid template' do
      template = mock_model(Template, :content => '{{ page.title }}')
      page = mock_model(Page,
        :current! => true,
        :template => template,
        :pages => [],
        :parent => nil,
        :to_liquid => { 'title' => 'Foo Title' })
      pages = []
      pages.stub :find_by_path => page

      site = mock_model(Site, :current! => true, :pages => pages, :homepage => page)
      Site.stub :first => site, :current => site
      Page.stub :current => page
      get :show
      response.body.should == 'Foo Title'
    end
  end

  context 'when a page does not exist' do
    before(:each) do
      pages = []
      pages.stub :find_by_path => nil

      site = mock_model(Site, :current! => true, :pages => pages, :homepage => nil)
      Site.stub :first => site, :current => site
      get :show
    end

    it 'returns a status of 404' do
      response.status.should == 404
    end

    it 'returns the 404 page' do
      response.body.should_not be_empty
    end
  end
end
