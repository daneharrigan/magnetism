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

  describe '#create' do
    it 'renders the template_sets/item partial' do
      params = {}
      params[:theme_id] = Factory(:theme).id
      params[:template_set] = { :name => 'Template Set Name' }

      post :create, params
      response.should render_template('admin/template_sets/_item')
    end
  end

  describe '#destroy' do
    it 'renders the template_sets/destroy.js template' do
      theme = mock_theme
      template_set = Factory(:template_set, :theme => theme)
      template_sets = [template_set]

      template_sets.stub :find => template_set
      theme.stub :template_sets => template_sets
      Theme.stub :find => theme

      params = { :theme_id => theme.id, :id => template_set.id }
      params[:format] = 'js'

      delete :destroy, params
      response.should render_template('admin/template_sets/destroy')
    end
  end
end
