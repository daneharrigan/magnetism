module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :overlay => :new, :none => [:edit, :update, :create, :destroy]
    belongs_to :theme
    helper_method :association_group, :page_template?

    def update
      if params[:position]
        ids = params[:position]
        values = (1..ids.count).map { |i| {:position => i} }
        resource.fields.update(ids, values)

        render :nothing => true
      else
        update! do |success, failure|
          success.json { render :json => {:notice => 'Template was successfully updated.'} }
          failure.json { render :json => {:failure => 'Template could not be updated.'} }
        end
      end
    end

    def create
      create! do |success, failure|
        success.html { render :partial => 'item', :locals => { :template => resource, :theme => parent} }
      end
    end

    def destroy
      resource.destroy
    end

    def association_group(field)
      [association_chain, resource, field].flatten
    end

    def page_template?
      resource.template_type == TemplateType.page
    end
  end
end
