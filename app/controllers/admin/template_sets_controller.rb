module Admin
  class TemplateSetsController < MagnetismController
    actions :all, :except => [:index, :show, :update]
    layout_options :overlay => [:new, :edit], :none => [:update, :create, :destroy]
    belongs_to :theme

    def create
      create! do |success, failure|
        success.html { render :partial => 'item', :locals => { :template_set => resource, :theme => parent} }
      end
    end
  end
end
