module Admin
  class PagesController < MagnetismController
    actions :all
    helper :page, :field
    layout_options :overlay => :new, :none => :destroy

    helper_method :homepage

    def edit
      current_site.current!
      resource.current!
      edit!
    end

    def update
      current_site.current!
      resource.current!

      update! do |success, failure|
        success.html do
          flash[:success] = flash[:notice]
          flash.delete :notice
        end
        failure.html { flash[:failure] = 'Page could not be updated.' }
      end

      redirect_to edit_admin_page_path(resource)
    end

    alias :show :redirect_to_edit
    alias :destroy :render_destroy_js

    protected
      alias :begin_of_association_chain :current_site

      def collection
        @pages ||= homepage.try(:pages) || []
      end

      def homepage
        @homepage ||= begin_of_association_chain.homepage
      end
  end
end
