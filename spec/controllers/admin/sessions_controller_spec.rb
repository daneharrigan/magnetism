require 'spec_helper'

describe Admin::SessionsController do
  describe '#show' do
    it 'redirects the user to session/new' do
      get :show
      response.should redirect_to new_admin_session_path
    end
  end

  describe '#new' do
    before(:each) { get :new }

    it 'renders sessions/new' do
      response.should render_template('sessions/new')
    end

    it 'renders layouts/sessions' do
      response.should render_template('layouts/sessions')
    end
  end

  describe '#create' do
    it 'redirects the user to /admin' do
      user = Factory(:user)
      params = {}
      params[:session] = {
        :email => user.email,
        :password => 'password'
      }
      post :create, params

      response.should redirect_to dashboard_path
    end
  end

  describe '#destroy' do
    it 'redirects the user to /admin' do
      controller.stub :current_user => Factory(:user)
      delete :destroy

      response.should redirect_to dashboard_path
    end
  end
end