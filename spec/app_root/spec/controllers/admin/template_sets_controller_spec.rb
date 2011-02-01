require 'spec_helper'

describe Admin::TemplateSetsController do
  before(:each) { sign_in Factory(:user) }

  describe '#new' do
    before(:each) do
      theme = Factory(:theme)
      params = { :theme_id => theme.id }
      get :new, params
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end

    it 'renders template_sets/new' do
      response.should render_template('admin/template_sets/new')
    end
  end
end
