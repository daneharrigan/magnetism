require 'spec_helper'

describe Admin::SessionsController do
  before(:each) do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#show' do
    it 'redirects the user to session/new' do
      get :show
      response.should redirect_to new_user_session_path
    end
  end

  describe '#new' do
    before(:each) { get :new }

    it 'renders admin/sessions/new' do
      response.should render_template('admin/sessions/new')
    end

    it 'renders layouts/sessions' do
      response.should render_template('layouts/sessions')
    end
  end

  describe '#create' do
    it 'redirects the user to /admin' do
      user = Factory(:user)
      params = {}
      params[:user] = {
        :login => user.login,
        :password => 'password'
      }
      post :create, params

      response.should redirect_to user_root_path
    end
  end

  describe '#destroy' do
    it 'redirects the user to /admin' do
      sign_in Factory(:user)
      delete :destroy

      response.should redirect_to new_user_session_path
    end
  end
end
