module Admin
  class SessionsController < Devise::SessionsController
    layout 'sessions'

    protected
      def after_sign_out_path_for(resource)
        sign_in_path
      end
  end
end
