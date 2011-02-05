module TemplateHelper
  def template_type
    return unless params[:template_type_id]
    @template_type ||= TemplateType.find(params[:template_type_id])
  end

  def page_template?
    resource.template_type == TemplateType.page && resource.template_set.nil?
  end
end
