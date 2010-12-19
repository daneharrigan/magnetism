require 'spec_helper'

describe Admin::PagesController do
  before(:each) { login_as Factory(:user) }

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

    it 'renders layouts/application.haml' do
      response.should render_template('layouts/application')
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

    context 'when a parent_id parameter is passed' do
      it 'returns the parent page from the parent_page helper' do
        page = Factory(:page, :site => @site)
        params = { :parent_id => page.id }

        get :new, params
        controller.send(:parent_page).should == page
      end
    end

    describe '#template_collection' do
      it 'returns an array of templates' do
        params = {}
        session = { :site_id => @site.id }
        template = Factory(:template, :theme => @site.theme)
        get :new, params, session
        controller.send(:template_collection).should == @site.theme.templates
      end
    end
  end

  describe '#edit' do
    before(:each) do
      page = Factory(:page)
      params = { :id => page.id }

      get :edit, params
    end

    # need to clear the current page to treat each test as a new request
    after(:each) { Page.clear_current! }

    it 'renders page/edit' do
      response.should render_template('admin/pages/edit')
    end

    it 'renders layouts/application' do
      response.should render_template('layouts/application')
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

      it 'sets the flash[:success] message' do
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit page' do
        response.should redirect_to edit_admin_page_path(@page)
      end
    end

    context 'when a page does not update successfully' do
      before(:each) do
        pending 'might not be able to test this. could be an inherited resources thing.'

        site = @page.site
        pages = [@page]
        put :update, @params
      end

      it 'sets the flash[:failure] message' do
        flash[:failure].should_not be_nil
      end

      it 'redirects to the edit page' do
        response.should redirect_to edit_admin_page_path(@page)
      end
    end
  end
end
