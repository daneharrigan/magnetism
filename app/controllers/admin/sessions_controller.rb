module Admin
  class SessionsController < Clearance::SessionsController
    layout 'sessions'

    def show
      redirect_to new_admin_session_path
    end

    private
      def url_after_create
        dashboard_path
      end

      alias_method :url_after_destroy, :url_after_create
  end
end