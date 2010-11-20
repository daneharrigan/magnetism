module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :none => :edit
    belongs_to :theme
  end
end
