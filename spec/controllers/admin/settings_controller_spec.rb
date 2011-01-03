require 'spec_helper'

describe Admin::SettingsController do
  before(:each) { sign_in Factory(:user) }
  describe '#index' do
    it 'renders settings/index' do
      get :index
      response.should render_template('admin/settings/index')
    end
  end
end
