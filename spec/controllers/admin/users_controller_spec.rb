require 'spec_helper'

describe Admin::UsersController do
  before(:each) { sign_in Factory(:user) }

  describe '#index' do
    it 'redirects to admin/manage' do
      get :index
      response.should redirect_to admin_manage_path
    end
  end

  describe '#new' do
    before(:each) { get :new }

    it 'renders users/new' do
      response.should render_template('admin/users/new')
    end

    it 'renders layouts/overlay' do
      response.should render_template('layouts/overlay')
    end
  end

  describe '#create' do
    it 'redirects the user back to admin/manage' do
      params = {}
      params[:user] = {
        :name => 'John Smith',
        :email => 'john.smith@example.com',
        :login => 'jsmith',
        :password => 'foobar1',
        :password_confirmation => 'foobar1'
      }

      post :create, params
      response.should redirect_to admin_manage_path
    end
  end
end
