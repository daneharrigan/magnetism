module MagnetismHelper
  def section_stylesheet_link_tag
    relative_path = "/admin/stylesheets/#{controller.controller_name}"
    full_path = "#{Magnetism.stylesheet_root}/#{controller.controller_name}.*" 

    stylesheet_link_tag(relative_path) unless Dir.glob(full_path).empty?
  end

  def section_javascript_include_tag
    relative_path = "/admin/javascripts/#{controller.controller_name}"
    full_path = "#{Magnetism.javascript_root}/#{controller.controller_name}.*"

    javascript_include_tag(relative_path) unless Dir.glob(full_path).empty?
  end

  def site_selector_collection
    @site_selector_collection ||= Site.all.map { |site| link_to site.name, admin_manage_site_path(site) }
  end
end
