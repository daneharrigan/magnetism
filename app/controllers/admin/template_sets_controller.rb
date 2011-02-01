module Admin
  class TemplateSetsController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :overlay => [:new, :edit], :none => [:update, :create, :destroy]
    belongs_to :theme
  end
end
