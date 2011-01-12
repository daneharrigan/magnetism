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

  describe '#homepage?' do
    context 'when the page is the homepage' do
      it 'returns true' do
        page = Factory(:page)
        site = page.site
        site.homepage = page
        site.save!

        page.homepage?.should be_true
      end
    end

    context 'when the page is not the homepage' do
      it 'returns false' do
        page = Factory(:page)
        page.homepage?.should be_false
      end
    end
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

  describe '#find_by_path' do
    before(:each) do
      @homepage = Factory(:page, :slug => '/')
      @site = @homepage.site
      @site.homepage = @homepage
      @site.save!
    end

    it 'returns the homepage' do
      Page.find_by_path('').should == @homepage
    end

    it 'returns a top level page' do
      page = Factory(:page)
      @homepage.pages << page
      Page.find_by_path(page.slug).should == page
    end

    it 'returns a second level page' do
      page_1 = Factory(:page)
      page_2 = Factory(:page, :site => page_1.site, :template => page_1.template)

      @homepage.pages << page_1
      page_1.pages << page_2

      uri = [page_1.slug, page_2.slug].join('/')

      Page.find_by_path(uri).should == page_2
    end

    it 'returns a third level page' do
      page_1 = Factory(:page)
      page_2 = Factory(:page, :site => page_1.site, :template => page_1.template)
      page_3 = Factory(:page, :site => page_1.site, :template => page_1.template)

      @homepage.pages << page_1
      page_1.pages << page_2
      page_2.pages << page_3

      uri = [page_1.slug, page_2.slug, page_3.slug].join('/')

      Page.find_by_path(uri).should == page_3
    end

    context 'when a page cant be found' do
      it 'returns nil' do
        Page.find_by_path('does/not/exist').should be_nil
      end
    end
  end

  describe '#permalink' do
    it 'returns the full URL to the homepage' do
      homepage = Factory(:homepage)
      site = homepage.site
      site.homepage = homepage

      homepage.permalink.should == "http://#{site.domain}/"
    end

    it 'returns the full URL to the top level page' do
      homepage = Factory(:homepage)
      site = homepage.site
      site.homepage = homepage
      site.save!

      page = Factory(:page, :site => site, :parent => homepage)

      page.permalink.should == "http://#{site.domain}/#{page.slug}"
    end

    it 'returns the full URL to the sub page' do
      homepage = Factory(:homepage)
      site = homepage.site
      site.homepage = homepage
      site.save!

      page_1 = Factory(:page, :site => site, :parent => homepage)
      page_2 = Factory(:page, :site => site, :parent => page_1)

      page_2.permalink.should == "http://#{site.domain}/#{page_1.slug}/#{page_2.slug}"
    end

    it 'returns the full URL to the blog post'
  end
end
