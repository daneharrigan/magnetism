class DispatchController < PublicController
  include Magnetism::Cache

  def show
    render :text => Liquify.invoke(current_page.template.content)
  end
end
