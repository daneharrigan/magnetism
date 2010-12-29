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

    it 'sets @user as a User instance' do
      assigns(:user).class.should == User
    end

    it 'sets @user as a new record' do
      assigns(:user).new_record?.should == true
    end
  end
end
