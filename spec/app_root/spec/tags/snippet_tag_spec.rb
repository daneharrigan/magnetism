require 'spec_helper'

describe SnippetTag do
  before(:each) do
    content = '<p>{{ page.title }}</p>'
    templates = [mock_template(:content => content)]
    snippets = templates

    snippets.stub :first => snippets.first
    templates.stub :snippets => snippets
    theme = mock_theme(:templates => templates)

    @page = Page.new(:title => 'Page Title -1')
    @page.stub :fields => []
    @site = mock_site(:theme => theme, :homepage => @page, :pages => [])
    @page.site = @site

    Page.stub :current => @page
    Site.stub :current => @site
  end
  describe 'snippet "post"' do
    it 'renders the "post" snippet once' do
      output = Liquify.invoke('{% snippet "post" %}')
      snippet_matches = output.match /<p>#{@page.title}<\/p>/
      snippet_matches.length.should == 1
    end
  end

  describe 'snippet "post", collection: "pages", parent_uri: "/blog"' do
    before(:each) do
      blog = Page.new(:site => @site)
      page_1 = Page.new(:title => 'Page Title -1', :site => @site)
      page_2 = Page.new(:title => 'Page Title -2', :site => @site)

      blog.stub :fields => []
      page_1.stub :fields => []
      page_2.stub :fields => []

      blog.stub :pages => [page_1, page_2]
      Site.current.pages.stub :find_by_path => blog
    end

    it 'renders the "post" snippet 2 times' do
      output = Liquify.invoke('{% snippet "post", collection: "pages", as: "page", parent_uri: "/blog" %}')
      snippet_matches = output.match /<p>[^<\/p>](.*)<\/p>/
      snippet_matches.length.should == 2
    end
  end
end