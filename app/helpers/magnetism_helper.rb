module MagnetismHelper
  def section_stylesheet_link_tag
    full_path = "/admin/stylesheets/#{controller.controller_name}"
    stylesheet_link_tag(full_path) if File.exists?("#{Rails.root}/public#{full_path}.css")
  end

  def section_javascript_include_tag
    full_path = "/admin/javascripts/#{controller.controller_name}"
    javascript_include_tag(full_path) if File.exists?("#{Rails.root}/public#{full_path}.js")
  end

  def site_selector_collection
    @site_selector_collection ||= Site.all.map { |site| link_to site.name, admin_manage_site_path(site) }
  end
end
