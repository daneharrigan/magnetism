require 'spec_helper'

describe Admin::ThemesController do
  before(:each) { login_as Factory(:user) }

  describe '#new' do
    before(:each) { get :new }

    it 'renders the themes/new view' do
      response.should render_template('admin/themes/new')
    end

    it 'renders the layouts/overlay layout' do
      response.should render_template('layouts/overlay')
    end
  end

  describe '#edit' do
    it 'renders the themes/edit view'
    it 'renders the layouts/overlay layout'
  end

  describe '#show' do
    it 'renders themes/show' do
      theme = Factory(:theme)
      params = { :id => theme.id }
      get :show, params
      response.should render_template('admin/themes/show')
    end
  end
end