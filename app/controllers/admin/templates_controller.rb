module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :none => :edit
    belongs_to :theme
    helper_method :association_group

    def update
      if params[:position]
        ids = params[:position]
        values = (1..ids.count).map { |i| {:position => i} }
        resource.fields.update(ids, values)

        render :nothing => true
      else
        update!
      end
    end

    def association_group(field)
      [association_chain, resource, field].flatten
    end
  end
end
