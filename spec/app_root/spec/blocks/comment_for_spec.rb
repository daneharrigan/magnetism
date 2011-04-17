require 'spec_helper'

describe CommentFor do
  describe '{% comment_for page as: "c" %}' do
    before(:each) do
=begin
      @page = Factory.build(:blog_entry, :site => mock_site, :parent => mock_page(:blog_section? => true, :homepage? => true))
      @page.stub :assign_parent => true, :assign_template => true, :update_archive => true, :blog_entry? => true
      @page.save

      @page.site = site
=end
      @page = Factory.build(
        :blog_entry, :site => mock_site,
        :parent => mock_page(:blog_section? => true, :homepage? => true))
      @page.stub :permalink => '/2011/04/testing-comment-for'

      site = mock_site(:homepage => @page)
      site.stub_chain(:homepage, :pages, :published, :ordered).and_return([])

      Page.stub :current => @page
      Site.stub :current => site

      content = <<-STR
        {% comment_for page, as: 'c' %}
          {{ c.author_name }}
          {{ c.author_email }}
          {{ c.author_url }}
          {{ c.body }}
        {% endcomment_for %}
      STR

      @output = Liquify.invoke(content)
    end

    it 'has an opening form tag' do
      @output.should =~ /<form .*>/m
    end

    it 'submits the form to the permalink/comments of the page' do
      @output.should =~ /<form(.*)action="#{@page.permalink}\/comments"(.*)>/m
    end

    it 'has an author name field' do
      @output.should =~ /<input(.*)name="comment\[author_name\]"(.*)\/>/m
    end

    it 'has an author email field' do
      @output.should =~ /<input(.*)name="comment\[author_email\]"(.*)\/>/m
    end

    it 'has an author url field' do
      @output.should =~ /<input(.*)name="comment\[author_url\]"(.*)\/>/m
    end

    it 'has a body field' do
      @output.should =~ /<textarea(.*)name="comment\[body\]"(.*)>/m
    end

    it 'has a closing form tag' do
      @output.should =~ /<\/form>/m
    end
  end
end
