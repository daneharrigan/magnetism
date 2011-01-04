module MagnetismHelper
  def site_selector_collection
    @site_selector_collection ||= Site.all.map { |site| link_to site.name, admin_manage_site_path(site) }
  end
end
