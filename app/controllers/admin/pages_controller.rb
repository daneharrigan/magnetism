module Admin
  class PagesController < MagnetismController
    actions :all
    helper_method :homepage, :parent_page, :template_collection
    helper :page, :field
    layout_options :overlay => :new, :none => :destroy

    def edit
      current_site.current!
      resource.current!
      edit!
    end

    def update
      current_site.current!
      resource.current!

      update! do |success, failure|
        success.html { }
        failure.html { flash[:failure] = 'Page could not be updated.' }
      end

      redirect_to edit_admin_page_path(resource)
    end

    alias :show :redirect_to_edit
    alias :destroy :render_destroy_js

    protected
      alias :begin_of_association_chain :current_site

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
        @template_collection ||= current_site.theme.templates.pages
      end
  end
end
