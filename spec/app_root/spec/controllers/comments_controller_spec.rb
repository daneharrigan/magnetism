require 'spec_helper'

describe CommentsController do
  describe '#create' do
    context 'when the page requested does not exist' do
      it 'returns a 404 page' do
        request.stub :fullpath => '/blog/does/not/exist'

        post :create
        response.status.should == 404
      end
    end

    context 'when the page exists but is not a blog entry' do
      it 'returns a 404 page' do
        controller.stub :current_page => mock_page(:blog_entry? => false)

        post :create
        response.status.should == 404
      end
    end

    context 'when the page exists and is a blog entry, but does not have comment params' do
      it 'returns a 404 page' do
        controller.stub :current_page => mock_page(:blog_entry? => true)

        post :create
        response.status.should == 404
      end
    end

    context 'when the page exists and is a blog entry and comment params are sent' do
      before(:each) do
        @page = Factory.build(:blog_entry, :site => mock_site, :parent => mock_page(:blog_section? => true))
        @page.stub :assign_template => true, :update_archive => true,
          :permalink => 'http://localhost/blog-article'
        @page.save

        controller.stub :current_page => @page
        @params = {}
        @params[:comment] = {
          :author_name => 'Dane Harrigan',
          :author_email => 'dane@example.com',
          :author_url => 'http://localhost',
          :body => 'Comments!' }
      end

      it 'creates a new comment' do
        lambda { post :create, @params }.should change(@page.comments, :count).by(+1)
      end

      it 'redirects back to the blog entry' do
        post :create, @params
        response.should redirect_to @page.permalink
      end
    end
  end
end
