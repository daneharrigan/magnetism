module ApplicationHelper
  def section_stylesheet_link_tag
    full_path = "/admin/stylesheets/#{controller.controller_name}"
    stylesheet_link_tag(full_path) if File.exists?("#{Rails.root}/public#{full_path}.css")
  end

  def section_javascript_include_tag
    full_path = "/admin/javascripts/#{controller.controller_name}"
    javascript_include_tag(full_path) if File.exists?("#{Rails.root}/public#{full_path}.js")
  end
end