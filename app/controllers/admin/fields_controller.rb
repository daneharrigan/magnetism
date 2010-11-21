module Admin
  class FieldsController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :overlay => :new
    belongs_to :theme, :template
    helper_method :field_type_collection, :association_group

    def create
      field = parent.fields.create(params[:field])
      render :partial => 'item', :locals => { :field => field }
    end

    def destroy
      resource.destroy
      render :nothing => true
    end

    def field_type_collection
      @field_type_collection ||= FieldType.all
    end

    def association_group(field)
      [association_chain, field].flatten
    end
  end
end
