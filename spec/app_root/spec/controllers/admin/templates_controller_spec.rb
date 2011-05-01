require 'spec_helper'

describe Admin::TemplatesController do
  before(:each) { sign_in Factory(:user) }

  describe '#new' do
    before(:each) do
      theme = Factory(:theme)
      params = { :theme_id => theme.id }
      params[:template_type_id] = Factory(:template_type_page).id

      get :new, params
    end

    it 'renders the overlay layout' do
      response.should render_template('layouts/overlay')
    end

    it 'renders templates/new' do
      response.should render_template('admin/templates/new')
    end
  end

  describe '#edit' do
    describe '#association_group' do
      it 'returns an array of the theme, template and field' do
        field = Factory(:field)
        association_group = [field.template.theme, field.template, field]
        params = {
          :theme_id => field.template.theme.id,
          :id => field.template.id
        }

        get :edit, params
        controller.association_group(field).should == association_group
      end
    end
  end

  describe '#update' do
    before(:each) do
      @template = Factory(:template)
      @params = { :theme_id => @template.theme.id, :id => @template.id }
    end
    context 'when the position of the fields are posted' do
      before(:each) do
        @field_1 = Factory(:field, :template => @template)
        field_type = @field_1.field_type
        @field_2 = Factory(:field, :template => @template, :field_type => field_type)
        @field_3 = Factory(:field, :template => @template, :field_type => field_type)

        @params[:position] = [@field_3.id, @field_2.id, @field_1.id]

        put :update, @params
      end

      it 'reorders field_3 in position 1' do
        @template.fields[0].should == @field_3
      end

      it 'reorders field_2 in position 2' do
        @template.fields[1].should == @field_2
      end

      it 'reorders field_1 in position 3' do
        @template.fields[2].should == @field_1
      end
    end

    context 'when the template content is posted' do
      before(:each) do
        @content = '<h1>{{ site.name }}</h1>'
        @params[:template] = { :content => @content }
        @params[:format] = 'json'
      end

      it 'updates the template content field' do
        # the content attribute is set when Factory runs, so a reload
        # is needed to fetch the updated value
        put :update, @params
        @template.reload
        @template.content.should == @content
      end

      context 'when the update is successful' do
        it 'returns a json object of the notice message' do
          put :update, @params
          message = { :notice => I18n.t('flash.actions.update.notice', :resource_name => 'Template') }
          response.body.should == message.to_json
        end
      end

      context 'when the update fails' do
        it 'returns a json object of the failure message' do
          @template.stub :update_attributes => false, :errors => { :fail => true }
          templates = [@template]
          theme = @template.theme

          templates.stub :find => @template
          theme.stub :templates => templates
          Theme.stub :find => theme

          put :update, @params
          message = { :alert => I18n.t('flash.actions.update.alert', :resource_name => 'Template') }
          response.body.should == message.to_json
        end
      end
    end
  end

  describe '#create' do
    it 'renders the templates/item partial' do
      params = {}
      params[:theme_id] = Factory(:theme).id
      params[:template] = {
        :name => 'Template Name',
        :template_type_id => Factory(:template_type_page).id
      }

      post :create, params
      response.should render_template('admin/templates/_item')
    end
  end

  describe '#destroy' do
    it 'renders the templates/destroy.js template' do
      template = Factory(:template)
      params = { :theme_id => template.theme.id, :id => template.id }
      params[:format] = 'js'

      delete :destroy, params
      response.should render_template('admin/templates/destroy')
    end
  end
end
