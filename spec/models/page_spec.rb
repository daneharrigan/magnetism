require 'spec_helper'

describe Page do
  it { should belong_to(:site) }
  it { should belong_to(:parent) }
  it { should have_many(:pages) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:site_id) }

  context 'when a page exists' do
    before(:each) do
      Factory(:page)
    end

    it { should validate_uniqueness_of(:title).scoped_to(:site_id, :parent_id) }
    it { should validate_uniqueness_of(:slug).scoped_to(:site_id, :parent_id) }
  end

  describe '#generate_slug' do
    let(:site) { Factory(:site) }

    context 'when a page is created without a slug' do
      it 'generates a slug from based on the page title' do
        page = site.pages.create(:title => 'Page Title', :publish_at => 1.hour.ago)
        page.slug.should == 'page-title'
      end
    end

    context 'when a page is created with a slug' do
      it 'uses the provided slug' do
        page = site.pages.create(
          :title => 'Page Title',
          :slug => 'specific-page-title',
          :publish_at => 1.hour.ago)

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
        page = @site.pages.create(
          :title => 'Page Title - 1',
          :publish_at => 1.hour.ago)

        page.parent.should == @homepage
      end
    end

    context 'when a page is created with a parent specified' do
      it 'does not override the specified parent' do
        parent = Factory(:page, :site => @site)
        page = @site.pages.create(
          :title => 'Page Title - 1',
          :parent => parent,
          :publish_at => 1.hour.ago)

        page.parent.should == parent
      end
    end
  end

  # TODO DH:
  # it { should validate_presence_of(:publish_at) }
  # it { should validate_presence_of(:active) }
  # it { should validate_presence_of(:template_id) }
  # it { should belong_to(:template) }
  # it { should have_many(:data_sets) }
end
