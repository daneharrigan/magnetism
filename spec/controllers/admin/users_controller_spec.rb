require 'spec_helper'

describe Admin::UsersController do
  describe '#new' do
    before(:each) do
      sign_in Factory(:user)
      get :new
    end

    it 'sets @user as a User instance' do
      assigns(:user).class.should == User
    end

    it 'sets @user as a new record' do
      assigns(:user).new_record?.should == true
    end
  end
end
