require 'spec_helper'

describe Admin::DashboardController do
  it 'sends a user that is not logged in to session/new' do
    get :show
    response.should redirect_to new_user_session_path
  end

  context 'when a user is logged in' do
    before(:each) do
     sign_in Factory(:user)
      get :show
    end

    it 'renders dashboard/show' do
      response.should render_template('admin/dashboard/show') 
    end

    it 'renders layouts/application' do
      response.should render_template('layouts/application') 
    end
  end
end
