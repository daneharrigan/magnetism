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

  describe '#theme_collection' do
    it 'returns all of the themes' do
      theme = Factory(:theme)
      get :new
      controller.send(:theme_collection).should == [theme]
    end
  end

  describe '#new' do
    it 'renders the overlay layout' do
      get :new
      response.should render_template('layouts/overlay')
    end
  end

  describe '#edit' do
    before(:each) do
      site = Factory(:site)
      params = {:id => site.id}

      get :edit, params
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end
  end

  describe '#new' do
    it 'renders the overlay layout' do
      get :new
      response.should render_template('layouts/overlay')
    end
  end
  describe '#create' do
    before(:each) do
      @params = {}
      @params[:site] = { :name => 'Site Name -1', :domain => 'localhost-2', :theme_id => 1 }
    end

    context 'when successful' do
      before(:each) do
        post :create, @params
      end

      it 'sets the flash notice message' do
        flash[:notice].should_not be_nil
      end

      it 'redirects the user to /admin/manage/sites/<site_id>' do
        response.should redirect_to admin_manage_site_path(assigns(:site))
      end

      it 'creates a homepage for the site' do
        assigns(:site).should_not be_nil
      end
    end

    context 'when site creation fails' do
      before(:each) do
        @params[:site].delete :domain
        post :create, @params
      end

      it 'sets the flash failure message' do
        flash[:alert].should_not be_nil
      end

      it 'redirects the user to /admin/manage' do
        response.should redirect_to admin_manage_path
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      site = Factory(:site)
      @params = { :id => site.id, :format => 'js' }
    end

    it 'renders sites/destroy' do
      delete :destroy, @params
      response.should render_template('admin/sites/destroy')
    end

    it 'deletes the site' do
      lambda { delete :destroy, @params }.should change(Site, :count).by(-1)
    end
  end
end
