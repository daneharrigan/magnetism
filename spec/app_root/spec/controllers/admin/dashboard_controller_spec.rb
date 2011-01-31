require 'spec_helper'

describe Admin::DashboardController do
  it 'sends a user that is not logged in to session/new' do
    get :show
    response.should redirect_to new_user_session_path
  end

  context 'when a user is logged in' do
    before(:each) do
     sign_in Factory(:user)
    end

    it 'renders dashboard/show' do
      get :show
      response.should render_template('admin/dashboard/show') 
    end

    it 'renders layouts/magnetism' do
      get :show
      response.should render_template('layouts/magnetism') 
    end

    describe '#current_site' do
      before(:each) { Factory(:site) }

      it 'returns the first site' do
        get :show
        controller.current_site.should == Site.first
      end

      it 'returns the site stored in the session' do
        site = Factory(:site)
        session[:site_id] = site.id

        get :show
        controller.current_site.should == site
      end
    end
  end
end
