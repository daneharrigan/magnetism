require 'spec_helper'

describe DataDrop do
  context 'when pages are looped over and the data object is referenced' do
    before(:each) do
      site = Factory(:site)
      site.current!

      @page_1 = Factory(:page, :site => site, :parent => site.homepage)
      @page_1.current!
      template = @page_1.template

      @page_2 = Factory(:page, :site => site, :parent => site.homepage, :template => template)

      # add page.template.fields
      @template_field = Factory(:field, :template => template, :name => 'Name')

      @page_1.data.create(:field_name => @template_field.name, :entry => Factory(:string_datum))
      @page_2.data.create(:field_name => @template_field.name, :entry => Factory(:string_datum))
    end

    after(:each) do
      Site.clear_current!
      Page.clear_current!
    end

    it 'returns values scoped to each page item' do
      content = <<-STR
        {% for nav in navigation %}
          <p>{{ nav.data.name }}</p>
        {% endfor %}
      STR

      output = Liquify.invoke(content)

      output.should =~ /<p>#{@page_1.data.first.entry.value}<\/p>/
      output.should =~ /<p>#{@page_2.data.first.entry.value}<\/p>/
    end
  end
end
