module Admin
  class FieldsController < MagnetismController
    actions :all, :except => [:index, :show]
    belongs_to :theme, :template
    layout_options :overlay => [:edit, :new]
    helper_method :field_type_collection, :association_group

    def create
      field = parent.fields.create(params[:field])
      render :partial => 'span', :locals => { :field => field }
    end

    def destroy
      resource.destroy
      render :nothing => true
    end

    def update
      update! do |success, failure|
        success.html { render :partial => 'span', :locals => {:field => resource} }
      end
    end

    def field_type_collection
      @field_type_collection ||= FieldType.all
    end

    def association_group(field)
      [association_chain, field].flatten
    end
  end
end
