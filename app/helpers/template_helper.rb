module TemplateHelper
  def template_type
    return unless params[:template_type_id]
    @template_type ||= TemplateType.find(params[:template_type_id])
  end
end
