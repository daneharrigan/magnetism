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
    before(:each) do
      theme = Factory(:theme)
      @params = { :id => theme.id }
    end

    it 'renders themes/show' do
      get :show, @params
      response.should render_template('admin/themes/show')
    end

    describe '#snippet_collection' do
      it 'returns all of the templates of type "Snippet"' do
        template = Factory(:snippet)
        get :show, @params
        controller.snippet_collection.should == [template]
      end
    end

    describe '#javascript_collection' do
      it 'returns all of the templates of type "JavaScript"' do
        template = Factory(:javascript)
        get :show, @params
        controller.javascript_collection.should == [template]
      end
    end

    describe '#stylesheet_collection' do
      it 'returns all of the templates of type "Stylesheet"' do
        template = Factory(:stylesheet)
        get :show, @params
        controller.stylesheet_collection.should == [template]
      end
    end

    describe '#template_collection' do
      it 'returns all of the templates of type "Template"' do
        template = Factory(:template)
        get :show, @params
        controller.template_collection.should == [template]
      end
    end
  end
end