require 'spec_helper'

describe Admin::FieldsController do
  before(:each) do
    login_as Factory(:user)
    template = Factory(:template)
    @params = {
      :theme_id => template.theme.id,
      :template_id => template.id
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

    it 'renders _item partial' do
      post :create, @params
      response.should render_template('admin/fields/_item')
    end

    it 'creates a field' do
      lambda { post :create, @params }.should change(Field, :count).by(+1)
    end
  end
end
