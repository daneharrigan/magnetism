require 'spec_helper'

describe Admin::UsersController do
  let(:user) { Factory(:user) }
  before(:each) { sign_in user }

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

  describe '#destroy' do
    it 'renders users/destroy' do
      params = { :id => user.id }
      params[:format] = 'js'

      delete :destroy, params
      response.should render_template('admin/users/destroy')
    end
  end

  describe '#edit' do
    context 'when the user is viewing their own profile' do
      it 'renders users/edit' do
        params = { :id => user.id }
        get :edit, params

        response.should render_template('admin/users/edit')
      end
    end

    context 'when a user tries to view someone elses profile' do
      before(:each) do
        mock_user = mock_model(User)
        User.should_receive(:find).with(mock_user.id).and_return(mock_user)
        User.should_receive(:find).and_return(user)

        get :edit, { :id => mock_user.id }
      end

      it 'redirects them to /admin' do
        response.should redirect_to user_root_path
      end

      it 'gives them a flash error' do
        flash[:error].should_not be_nil
      end
    end
  end

  describe '#update' do
    before(:each) do
      @params = { :id => user.id }
      @params[:user] = {
        :name => 'Foo Bar',
        :password => '',
        :password_confirmation => ''
      }
    end

    it 'redirects the user to /admin/manage' do
      put :update, @params
      response.should redirect_to admin_manage_path
    end

    context 'when the update fails' do
      it 'sets the flash alert message' do
        user.stub :update_attributes => false, :errors => { :fail => true }
        User.stub :find => user

        put :update, @params
        flash[:alert].should_not be_nil
      end
    end
  end
end
