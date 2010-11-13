module Admin
  class UsersController < MagnetismController
    def new
      @user = User.new
    end
  end
end