module Admin
  class TemplatesController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :none => :edit
    helper_method :parent

    # NOTE DH: why the hell cant i use belongs_to?
    # belongs_to :theme

    protected
      def parent
        Theme.find(params[:theme_id])
      end
  end
end