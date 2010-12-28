class ApplicationController < ActionController::Base
  include LayoutOptions
  protect_from_forgery

  def after_sign_out_path_for(resource)
    user_root_path
  end
end
