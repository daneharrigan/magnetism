require 'spec_helper'

describe Admin::SitesController do
  before(:each) { sign_in Factory(:user) }

  describe '#show' do
    before(:each) do
      @site = Factory(:site)
      params = {:id => @site.id}

      get :show, params
    end

    it 'sets the session[:site_id] to the requested site.id' do
      session[:site_id].should == @site.id
    end

    it 'redirects the user to /admin/pages' do
      response.should redirect_to admin_pages_path
    end
  end
end
