class DispatchController < ApplicationController
  def show
    # page = Page.find_by_path(params[:path])
    # # NOTE: this method should exist in the old magnetism codebase
    render :text => 'HERE I AM'
  end
end
