module Admin
  class PagesController < MagnetismController
    actions :all
    helper_method :homepage, :parent_page
    layout_options :overlay => :new, :none => :destroy

    alias_method :show, :redirect_to_edit
    alias_method :destroy, :render_destroy_js

    def update
      update! do |success, failure|
        success.html { flash[:success] = 'Your page updated!' }
        failure.html { flash[:failure] = 'Is Broken' }
      end

      redirect_to edit_admin_page_path(resource)
    end

    protected
      alias_method :begin_of_association_chain, :current_site

      def homepage
        @homepage ||= begin_of_association_chain.homepage
      end

      def collection
        @pages ||= homepage.try(:pages) || []
      end

      def parent_page
        @_parent_page ||= current_site.pages.find(params[:parent_id]) if params[:parent_id]
      end
  end
end