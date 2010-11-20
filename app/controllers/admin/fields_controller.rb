module Admin
  class FieldsController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :overlay => :new
    belongs_to :theme, :template
    helper_method :field_type_collection

    def create
      field = parent.fields.create(params[:field])
      render :partial => 'item', :locals => { :field => field }
    end

    def field_type_collection
      @field_type_collection ||= FieldType.all
    end
  end
end
