require 'spec_helper'

describe Admin::ManagesController do
  before(:each) do
    sign_in Factory(:user)
    Factory(:site)

    get :show
  end

  it 'renders manages/show' do
    response.should render_template('admin/manages/show')
  end

  it 'has a site_collection helper that returns all sites' do
    controller.send(:site_collection).should == Site.all
  end

  it 'has a theme_collection helper that returns all themes' do
    Factory(:theme)
    controller.send(:theme_collection).should == Theme.all
  end

  it 'has a user_collection helper that returns all users' do
    controller.send(:user_collection).should == User.all
  end
end
