module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :none => :edit
    belongs_to :theme
    helper_method :association_group

    def association_group(field)
      [association_chain, resource, field].flatten
    end
  end
end
