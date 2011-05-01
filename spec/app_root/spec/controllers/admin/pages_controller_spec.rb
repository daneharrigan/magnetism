require 'spec_helper'

describe Admin::PagesController do
  before(:each) { sign_in Factory(:user) }

  let(:site) { Factory(:site) }

  describe '#index' do
    before(:each) do
      site.homepage = Factory(:page, :site => site)
      site.save!

      Factory(:page, :site => site, :parent => site.homepage)

      get :index
    end

    it 'renders pages/index.haml' do
      response.should render_template('admin/pages/index')
    end

    it 'renders layouts/magnetism' do
      response.should render_template('layouts/magnetism')
    end

    it 'has begin_of_association_chain returning the current site' do
      controller.send(:begin_of_association_chain).should == site
    end

    it 'has a homepage helper method returning the homepage of the current site' do
      controller.send(:homepage).should == site.homepage
    end

    it 'has collection returning the child pages of the homepage' do
      controller.send(:collection).should == site.homepage.pages
    end
  end

  describe '#new' do
    before(:each) { @site = Factory(:site) }

    it 'renders pages/new.haml' do
      get :new
      response.should render_template('admin/pages/new')
    end

    it 'renders layouts/overlay.haml' do
      get :new
      response.should render_template('layouts/overlay')
    end
  end

  describe '#edit' do
    let(:page) { Factory(:page) }

    # need to clear the current page to treat each test as a new request
    after(:each) { Page.clear_current! }

    context 'when a request is made without xhr' do
      before(:each) do
        params = { :id => page.id }
        get :edit, params
      end

      it 'renders page/edit' do
        response.should render_template('admin/pages/edit')
      end

      it 'renders layouts/magnetism' do
        response.should render_template('layouts/magnetism')
      end
    end

    context 'when a request is made with xhr' do
      before(:each) do
        params = { :id => page.id }
        xhr :get, :edit, params
      end

      it 'renders page/new' do
        response.should render_template('admin/pages/new')
      end

      it 'renders layouts/overlay' do
        response.should render_template('layouts/overlay')
      end
    end
  end

  describe '#show' do
    it 'redirects to the edit view' do
      page = Factory(:page)
      params = { :id => page.id }

      get :show, params
      response.should redirect_to edit_admin_page_path(page)
    end
  end

  describe '#destroy' do
    before(:each) do
      page = Factory(:page)
      @params = { :id => page.id, :format => 'js' }
    end

    it 'renders pages/destroy' do
      delete :destroy, @params
      response.should render_template('admin/pages/destroy')
    end

    it 'deletes the page' do
      lambda { delete :destroy, @params }.should change(Page, :count).by(-1)
    end
  end

  describe '#update' do
    before(:each) do
      @page = Factory(:page)
      @params = {}
      @params[:id] = @page.id
      @params[:page] = { :title => 'Page Title - Changed' }
      @params[:page][:fields] = {}

      field = Factory(:field_with_text_field, :template => @page.template)
      @page.template.fields << field
      @params[:page][:fields][field.input_name] = 'Changed Value'

      field = Factory(:field_with_large_text_field, :template => @page.template)
      @page.template.fields << field
      @params[:page][:fields][field.input_name] = 'Changed Value - 2'
    end

    # need to clear the current page to treat each test as a new request
    after(:each) { Page.clear_current! }

    context 'when a page updates successfully' do
      before(:each) { put :update, @params }

      it 'redirects to the edit page' do
        response.should redirect_to edit_admin_page_path(@page)
      end
    end

    context 'when a page does not update successfully' do
      before(:each) do
        site = @page.site
        @page.stub :update_attributes => false, :errors => { :fail => true }

        pages = [@page]
        pages.stub :find => @page

        site.stub :pages => pages
        Site.stub :first => site

        put :update, @params
      end

      it 'sets the flash[:alert] message' do
        flash[:alert].should_not be_nil
      end

      it 'renders the edit view' do
        response.should render_template('edit')
      end
    end

    context 'when uploading an asset to a page' do
      before(:each) do
        site = @page.site

        site.current!
        @page.current!

        @field = Factory(:field_with_asset, :template => @page.template)
        file = File.open(support_image_path('carrierwave/fpo.gif'))
        @params[:page][:fields][@field.input_name] = file
      end

      after(:each) do
        Site.clear_current!
        Page.clear_current!
      end

      it 'creates a new asset' do
        lambda { put :update, @params }.should change(Asset, :count).by(+1)
      end

      context 'when the asset field already has a file attached to it' do
        it 'does not create additional asset records' do
          @field.value =  File.open(support_image_path('carrierwave/fpo_2.gif'))
          lambda { put :update, @params }.should_not change(Asset, :count)
        end
      end
    end
  end
end
