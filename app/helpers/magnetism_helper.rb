module MagnetismHelper
  def site_selector_collection
    return @site_selector_collection if @site_selector_collection
    new_site = link_to 'New Site', new_admin_manage_site_path, :remote => true, :method => :get, 'data-type' => :html

    @site_selector_collection = Site.all.map { |site| link_to site.name, admin_manage_site_path(site) }
    @site_selector_collection << new_site
  end
end
