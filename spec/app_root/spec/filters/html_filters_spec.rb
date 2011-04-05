require 'spec_helper'

describe HTMLFilters do
  before(:each) do
    allow_message_expectations_on_nil
    Site.current.stub_chain(:homepage, :pages, :published, :ordered).and_return([])
    Site.current.stub :key => 'hash-value'
    Page.current.stub :parent => nil

    textile_content = <<-STR
h1. Header

Sample Paragraph Text
    STR

    liquify_content = <<-STR
{{ 'main' | stylesheet }}
{{ content | textile }}
<p>{{ item.publish_at | date_format: '%m/%d/%Y' }}</p>
{{ item | link_to }}
    STR

    @item = Page.new(:title => 'Page -1', :publish_at => Time.now)
    @item.stub :permalink => '/page-1'
    @output = Liquify.invoke(liquify_content, :content => textile_content, :item => @item)
  end

  describe '#textile' do
    it 'returns rendered textile output' do
      @output.should =~ /<h1>Header<\/h1>/
      @output.should =~ /<p>Sample Paragraph Text<\/p>/
    end
  end

  describe '#stylesheet' do
    it 'returns a stylesheet tag scoped to the current site' do
      css_url = "/assets/#{Site.current.key}/stylesheets/main.css"
      @output.should =~ /<link href="#{css_url}".*\/>/
    end
  end

  describe '#date_format' do
    it 'returns a formatted date/time' do
      @output.should =~ /<p>#{@item.publish_at.strftime('%m/%d/%Y')}<\/p>/
    end
  end

  describe '#link_to' do
    it 'returns a link to the page' do
      @output.should =~ /<a href="#{@item.permalink}" title="#{@item.title}">#{@item.title}<\/a>/
    end
  end
end
