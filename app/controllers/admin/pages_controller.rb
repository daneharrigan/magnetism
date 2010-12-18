module Admin
  class PagesController < MagnetismController
    actions :all
    helper_method :homepage, :parent_page, :template_collection
    layout_options :overlay => :new, :none => :destroy

    alias_method :show, :redirect_to_edit
    alias_method :destroy, :render_destroy_js

    def edit
      resource.current!
      edit!
    end

    def update
      resource.current!
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
        @parent_page ||= current_site.pages.find(params[:parent_id]) if params[:parent_id]
      end

      def template_collection
        @template_collection ||= current_site.theme.templates
      end
  end
end
