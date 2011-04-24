require 'spec_helper'

describe DispatchController do
  context 'when a page exists' do
    it 'outputs the rendered liquid template' do
      template = mock_model(Template, :content => '{{ page.title }}')
      page = mock_page(:current! => true, :template => template,
        :parent => nil, :to_liquid => { 'title' => 'Foo Title' })

      page.stub_chain(:pages, :published, :ordered).and_return([])
      pages = []
      pages.stub :find_by_path => page

      site = mock_site(:current! => true, :pages => pages, :homepage => page)
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

      site = mock_site(:current! => true, :pages => pages, :homepage => nil)
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

  context 'when the URL requested is a redirect to a page' do
    before(:each) do
      @page = Factory(:page)
      page_redirect = @page.redirects.create(:url => '/some/old/url', :site => @page.site)
      controller.stub :current_site => @page.site
      request.stub :fullpath => page_redirect.url

      get :show
    end

    it 'redirects the user to the appropraite page permalink' do
      response.should redirect_to @page.permalink
    end

    it 'sets the 301 status code' do
      response.status.should == 301
    end
  end

  context 'when posting a comment' do
    before(:each) do
      @page = Factory.build(:blog_entry, :site => mock_site, :parent => mock_page(:blog_section? => true))
      @page.stub :assign_template => true, :update_archive => true,
        :permalink => 'http://localhost/blog-article', :comment? => true
      @page.save

      site = mock_site(:current! => true, :homepage => @page)
      Site.stub :first => site, :current => site
      Page.stub :current => @page

      controller.stub :current_page => @page

      @params = {}
      @params[:comment] = {
        :author_name => 'Dane Harrigan',
        :author_email => 'dane@example.com',
        :author_url => 'http://localhost',
        :body => 'Comments!' }
    end

    it 'creates a new comment for the blog post' do
      lambda { post :show, @params }.should change(Comment, :count).by(+1)
    end

    it 'redirects back to the blog post' do
      post :show, @params
      response.should redirect_to @page.permalink
    end
  end
end
