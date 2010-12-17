require 'spec_helper'

describe Page do
  it { should belong_to(:site) }
  it { should belong_to(:parent) }
  it { should belong_to(:template) }
  it { should have_many(:pages) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:site_id) }
  it { should validate_presence_of(:template_id) }

  context 'when a page exists' do
    before(:each) do
      Factory(:page)
    end

    it { should validate_uniqueness_of(:title).scoped_to(:site_id, :parent_id) }
    it { should validate_uniqueness_of(:slug).scoped_to(:site_id, :parent_id) }
  end

  describe '#generate_slug' do
    let(:site) { Factory(:site) }
    let(:template) { Factory(:template) }

    context 'when a page is created without a slug' do
      it 'generates a slug from based on the page title' do
        page = site.pages.create(:title => 'Page Title',
          :publish_at => 1.hour.ago,
          :template => template)
        page.slug.should == 'page-title'
      end
    end

    context 'when a page is created with a slug' do
      it 'uses the provided slug' do
        page = site.pages.create(
          :title => 'Page Title',
          :slug => 'specific-page-title',
          :publish_at => 1.hour.ago,
          :template => template)

        page.slug.should == 'specific-page-title'
      end
    end
  end

  describe '#assign_parent' do
    before(:each) do
      @homepage = Factory(:page)
      @site = @homepage.site
      @site.homepage = @homepage
      @site.save!
    end

    context 'when a page is created without a parent specified' do
      it 'gets assigned as a top-level page' do
        page = Factory(:page, :site => @site, :parent_id => nil)
        page.parent.should == @homepage
      end
    end

    context 'when a page is created with a parent specified' do
      it 'does not override the specified parent' do
        parent = Factory(:page, :site => @site)
        page = Factory(:page, :site => @site, :parent_id => parent.id)
        page.parent.should == parent
      end
    end
  end

  describe '#fields=' do
    it 'calls Field#field= on each of the fields in the collection' do
      page = Factory(:page)
      page.current!
      args = {}

      field = Factory(:field_with_text_field)
      page.template.fields << field
      args[field.input_name] = 'John Doe'

      field = Factory(:field_with_large_text_field, :template => field.template)
      page.template.fields << field
      args[field.input_name] = 'Lorem Ipsum'

      page.fields = args

      page.fields.each do |field|
        field.value.should == args[field.input_name]
      end
    end
  end
end
