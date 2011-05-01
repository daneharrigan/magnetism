module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    respond_to :html
    respond_to :json, :only => :update
    layout_options :overlay => :new, :none => [:edit, :update, :create, :destroy]
    belongs_to :theme
    helper_method :association_group
    helper :template, :field

    def update
      if params[:position]
        ids = params[:position]
        values = (1..ids.count).map { |i| {:position => i} }
        resource.fields.update(ids, values)

        render :nothing => true
      else
        update! do |success, failure|
          resource_name = resource_class.name.titleize
          success.json do
            render :json => { :notice => I18n.t('flash.actions.update.notice', :resource_name => resource_name) }
          end

          failure.json do
            render :json => { :alert => I18n.t('flash.actions.update.alert', :resource_name  => resource_name) }
          end
        end
      end
    end

    def create
      create! do |success, failure|
        success.html do
          flash.delete :notice
          render :partial => 'item', :locals => { :template => resource, :theme => parent}
        end
      end
    end

    def association_group(field)
      [association_chain, resource, field].flatten
    end

    alias :destroy :render_destroy_js
  end
end
