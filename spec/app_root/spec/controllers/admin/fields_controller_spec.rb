require 'spec_helper'

describe Admin::FieldsController do
  before(:each) do
    sign_in Factory(:user)
    @template = Factory(:template)
    @params = {
      :theme_id => @template.theme.id,
      :template_id => @template.id
    }
  end

  describe '#new' do
    before(:each) { get :new, @params }

    it 'renders the new template' do
      response.should render_template('admin/fields/new')
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end

    describe '#field_type_collection' do
      it 'returns all of the field types' do
        Factory(:field_type)
        controller.field_type_collection.should == FieldType.all
      end
    end
  end

  describe '#create' do
    before(:each) do
      @params[:field] = {
        :name => 'Sample field name',
        :field_type_id => Factory(:field_type_text_field).id
      }
    end

    it 'renders _span partial' do
      post :create, @params
      response.should render_template('admin/fields/_span')
    end

    it 'creates a field' do
      lambda { post :create, @params }.should change(Field, :count).by(+1)
    end

    describe '#association_group' do
      it 'returns an array of the theme, template and field' do
        post :create, @params
        field = Field.last
        association_group = [field.template.theme, field.template, field].flatten
        controller.association_group(field).should == association_group
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      field = Factory(:field, :template => @template)
      @params[:id] = field.id
      @params[:format] = 'js'
    end

    it 'deletes a field' do
      lambda { delete :destroy, @params }.should change(Field, :count).by(-1)
    end

    it 'does not render anything' do
      delete :destroy, @params
      response.body.strip.empty?.should == true
    end

    it 'returns a status of OK' do
      response.status.should == 200
    end
  end

  describe '#edit' do
    before(:each) do
      field = Factory(:field, :template => @template)
      @params[:id] = field.id
      get :edit, @params
    end

    it 'renders the edit template' do
      response.should render_template('admin/fields/edit')
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end
  end

  describe '#update' do
    before(:each) do
      field = Factory(:field, :template => @template)
      @params[:id] = field.id
      @params[:field] = { :name => 'Changed Value' }
      put :update, @params
    end

    it 'renders _span partial' do
      response.should render_template('admin/fields/_span')
    end
  end
end
