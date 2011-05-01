module Admin
  class PagesController < MagnetismController
    actions :all
    helper :page, :field
    layout_options :overlay => :new, :none => :destroy

    helper_method :homepage

    def edit
      current_site.current!
      resource.current!
      if request.xhr?
        @page = begin_of_association_chain.pages.find(params[:id])
        render 'new', :layout => 'overlay', :locals => { :title => 'Edit Page' }
      else
        edit!
      end
    end

    def update
      current_site.current!
      resource.current!
      update! { edit_admin_page_path(resource) }
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
