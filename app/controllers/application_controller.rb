class ApplicationController < ActionController::Base
  include LayoutOptions
  include Clearance::Authentication
  protect_from_forgery
end
