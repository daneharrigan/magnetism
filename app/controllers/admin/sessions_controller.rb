module Admin
  class SessionsController < Devise::SessionsController
    layout 'sessions'
    helper :magnetism

    def show
      redirect_to new_user_session_path
    end

    protected
      def after_sign_out_path_for(resource)
        new_user_session_path
      end
  end
end
