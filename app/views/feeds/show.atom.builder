atom_feed(:url => "#{@current_page.permalink(true)}/feed.atom") do |feed|
  feed.title    @current_site.name
  feed.generator "Magnetism #{Magnetism::VERSION}"
  feed.updated  @current_page.subpages.first.publish_at
  feed.author do |author|
    author.name @current_site.name
  end

  @current_page.subpages.each do |page|
    feed.entry(page, :url => page.permalink(true), :id => page.permalink(true), :updated => page.publish_at) do |entry|
      entry.title   page.title
      entry.link    :href => page.permalink(true)
      entry.summary page.html_excerpt, :type => :html
      entry.content page.full_content, :type => :html
    end
  end
end
