require 'spec_helper'

describe Admin::FieldsController do
  before(:each) { login_as Factory(:user) }
  describe '#new' do
    before(:each) do
      template = Factory(:template)
      params = {
        :theme_id => template.theme.id,
        :template_id => template.id
      }
      get :new, params
    end

    it 'renders the new template' do
      response.should render_template('admin/fields/new')
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end
  end
end
