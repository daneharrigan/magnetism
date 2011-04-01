require 'spec_helper'

describe Page do
  it { should belong_to(:site) }
  it { should belong_to(:parent) }
  it { should belong_to(:template) }
  it { should belong_to(:template_set) }
  it { should have_many(:pages) }
  it { should have_many(:data) }
  it { should have_one(:blog) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:site_id) }
  # it { should validate_presence_of(:template_id) }
  # TODO: need to test can_be_published

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
        site = Factory.build(:site)
        page = Factory.build(:page, :site => site)
        site.homepage = page

        page.homepage?.should be_true
      end
    end

    context 'when the page is not the homepage' do
      it 'returns false' do
        site = Factory.build(:site)
        page = Factory.build(:page, :site => site)
        page.homepage?.should be_false
      end
    end
  end

  describe '#generate_slug' do
    let(:site) { Factory(:site) }

    context 'when a page is created without a slug' do
      it 'generates a slug from based on the page title' do
        page = site.pages.create(:title => 'Page Title',
          :publish_at => 1.hour.ago,
          :template => mock_template)
        page.slug.should == 'page-title'
      end
    end

    context 'when a page is created with a slug' do
      it 'uses the provided slug' do
        page = site.pages.create(
          :title => 'Page Title',
          :slug => 'specific-page-title',
          :publish_at => 1.hour.ago,
          :template => mock_template)

        page.slug.should == 'specific-page-title'
      end
    end
  end

  describe '#assign_parent' do
    before(:each) do
      @homepage = Factory(:page, :template => mock_template)
      @site = @homepage.site
      @site.homepage = @homepage
      @site.save!
    end

    context 'when a page is created without a parent specified' do
      it 'gets assigned as a top-level page' do
        page = Factory(:page, :site => @site,
          :parent_id => nil,
          :template => mock_template)
        page.parent.should == @homepage
      end
    end

    context 'when a page is created with a parent specified' do
      it 'does not override the specified parent' do
        parent = Factory(:page, :site => @site, :template => mock_template)
        page = Factory(:page, :site => @site,
          :parent_id => parent.id, :template => mock_template)
        page.parent.should == parent
      end
    end
  end

  describe '#assign_template' do
    before(:each) do
      @template_set = Factory(:template_set)
      @blog_index = Factory(:template, :name => 'Index',
        :theme => @template_set.theme,
        :template_set_id => @template_set.id)
    end

    context 'when a blog section is created' do
      it 'gets assigned the "Index" template' do
        page = Factory(:blog_section, :template_set => @template_set, :template => nil)
        page.template.should == @blog_index
      end
    end

    context 'when a blog post is created' do
      it 'gets assigned the "Post" template' do
        blog_post = Factory(:template, :name => 'Post',
          :theme => @template_set.theme,
          :template_set => @template_set,
          :template_type => @blog_index.template_type)
        parent = Factory(:blog_section, :template_set => @template_set, :template => nil)
        page = Factory(:blog_entry, :parent => parent, :site => parent.site, :template => nil)

        page.template.should == blog_post
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

  describe '.find_by_path' do
    before(:each) do
      @site = Factory(:site)
      @homepage = @site.homepage
      @homepage.update_attributes(:publish => true, :publish_at => 1.hour.ago)
    end

    it 'returns the homepage' do
      Page.find_by_path('/').should == @homepage
    end

    it 'returns a top level page' do
      page = Factory(:page, :template => mock_template, :site => @site)
      @homepage.pages << page
      uri = '/' << page.slug
      Page.find_by_path(uri).should == page
    end

    it 'returns a second level page' do
      page_1 = Factory(:page, :template => mock_template, :site => @site)
      page_2 = Factory(:page, :template => mock_template, :site => @site)

      @homepage.pages << page_1
      page_1.pages << page_2

      uri = '/' << [page_1.slug, page_2.slug].join('/')
      Page.find_by_path(uri).should == page_2
    end

    it 'returns a third level page' do
      page_1 = Factory(:page, :site => @site, :template => mock_template)
      page_2 = Factory(:page, :site => @site,
        :template => mock_template, :parent => page_1)
      page_3 = Factory(:page, :site => @site,
        :template => mock_template, :parent => page_2)

      uri = '/' << [page_1.slug, page_2.slug, page_3.slug].join('/')

      Page.find_by_path(uri).should == page_3
    end

    context 'when a page cant be found' do
      it 'returns nil' do
        Page.find_by_path('/does/not/exist').should be_nil
      end
    end

    context 'when a page is a blog post' do
      before(:each) do
        @homepage.blog_section = true

        template = mock_template

        templates = [template]
        template_set = templates
        templates_by_name = templates

        templates_by_name.stub :first => template
        templates.stub :by_name => templates_by_name
        template_set.stub :templates => templates

        @subpage = Factory.build(:page, :parent => @homepage, :site => @homepage.site)
        @subpage.parent.stub :template_set => template_set
        @subpage.save
      end

      context 'when the request is /<year>/<month>/<day>/slug' do
        it 'should return the blog page' do
          @homepage.update_attribute(:uri_format, ':year/:month/:day/:slug')
          path = "/#{@subpage.publish_at.strftime('%Y/%m/%d')}/#{@subpage.slug}"
          
          Page.find_by_path(path).should == @subpage
        end 
      end 

      context 'when the request is /<year>/<month>/page-path is requested' do
        it 'should return the blog page' do
          @homepage.update_attribute(:uri_format, ':year/:month/:slug')
          path = "/#{@subpage.publish_at.strftime('%Y/%m')}/#{@subpage.slug}"

          Page.find_by_path(path).should == @subpage
        end
      end

      context 'when /<page-id>/path-name is requested' do
        it 'should return a blog page' do
          @homepage.update_attribute(:uri_format, ':id/:slug')
          path = "/#{@subpage.id}/#{@subpage.slug}"

          Page.find_by_path(path).should == @subpage
        end
      end

      context 'when /<page-id>-path-name is requested' do
        it 'should return the blog page' do
          @homepage.update_attribute(:uri_format, ':id-:slug')
          path = "/#{@subpage.id}-#{@subpage.slug}"

          Page.find_by_path(path).should == @subpage
        end
      end
    end

    context 'when a page is a blog post within a subsection' do
      before(:each) do
        @section = Factory.build(:blog_section, :parent => @homepage, :site => @homepage.site)

        template = mock_template

        templates = [template]
        template_set = templates
        templates_by_name = templates

        templates_by_name.stub :first => template
        templates.stub :by_name => templates_by_name
        template_set.stub :templates => templates
        @section.stub :template_set => template_set
        @section.save
        @subpage = Factory(:blog_entry, :parent => @section, :site => @homepage.site)
      end

      context 'when the request is /<section>/<year>/<month>/<day>/<slug>' do
        it 'should return the blog page' do
          path = "/#{@section.slug}/#{@subpage.publish_at.strftime('%Y/%m/%d')}/#{@subpage.slug}"
          
          Page.find_by_path(path).should == @subpage
        end 
      end 
    end
  end

  describe '#permalink' do
    before(:each) do
      template_set = Factory(:template_set)
      Factory(:template, :name => 'Post', :theme => template_set.theme, :template_set_id => template_set.id)

      @site = Factory(:site)
      @homepage = @site.homepage
      @homepage.update_attribute(:template_set, template_set)
    end

    it 'returns the full URL to the homepage' do
      @homepage.permalink.should == '/'
    end

    it 'returns the full URL to the top level page' do
      page = Factory(:page, :site => @site,
        :parent => @homepage, :template => mock_template)
      page.permalink.should == "/#{page.slug}"
    end

    it 'returns the full URL to the sub page' do
      page_1 = Factory(:page, :site => @site,
        :parent => @homepage, :template => mock_template)
      page_2 = Factory(:page, :site => @site,
         :parent => page_1, :template => mock_template)

      page_2.permalink.should == "/#{page_1.slug}/#{page_2.slug}"
    end

    context 'when the uri_format is :year/:month/:day/:slug' do
      it 'returns the full URL to the blog post' do
        @homepage.update_attributes(:blog_section => true,
          :uri_format => ':year/:month/:day/:slug')

        page = Factory(:page, :parent => @homepage, :site => @site)
        page.permalink.should == "/#{page.publish_at.strftime('%Y/%m/%d')}/#{page.slug}"
      end
    end

    context 'when the uri_format is :year/:month/:slug' do
      it 'returns the full URL to the blog post' do
        @homepage.update_attributes(:blog_section => true,
          :uri_format => ':year/:month/:slug')

        page = Factory(:page, :parent => @homepage, :site => @site)
        page.permalink.should == "/#{page.publish_at.strftime('%Y/%m')}/#{page.slug}"
      end
    end

    context 'when the uri_format is :id/:slug' do
      it 'returns the full URL to the blog post' do
        @homepage.update_attributes(:blog_section => true, :uri_format => ':id/:slug')

        page = Factory(:page, :parent => @homepage, :site => @site)
        page.permalink.should == "/#{page.id}/#{page.slug}"
      end
    end

    context 'when the uri_format is :id-:slug' do
      it 'returns the full URL to the blog post' do
        @homepage.update_attributes(:blog_section => true, :uri_format => ':id-:slug')

        page = Factory(:page, :parent => @homepage, :site => @site)
        page.permalink.should == "/#{page.id}-#{page.slug}"
      end
    end
  end

  describe '#publish_at' do
    context 'when there is no publish_at value' do
      it 'returns Time.now' do
        time = Time.now
        Time.stub :now => time
        Page.new.publish_at.should == Time.now
      end
    end

    context 'when there is a publish_at value' do
      it 'gets returned' do
        publish_at = 2.days.ago
        Page.new(:publish_at => publish_at).publish_at.should == publish_at
      end
    end
  end

  describe '#blog_entry?' do
    context 'when the parent is a blog section' do
      it 'returns true' do
        page = Page.new :parent => Page.new(:blog_section => true)
        page.blog_entry?.should == true
      end
    end

    context 'when the parent is not a blog section' do
      it 'returns false' do
        page = Page.new
        page.blog_entry?.should be_nil 
      end
    end
  end

  describe '#cache_path' do
    it 'returns the file system path of where to write a static file' do
      page = Factory.build(:page)
      page.cache_path.should == "#{Rails.public_path}/cache/#{page.site.domain}#{page.permalink}.html"
    end
  end
end
