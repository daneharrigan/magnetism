class FeedsController < PublicController
  def show
    @current_site = current_site
    @current_page = current_page
    #.pages.published.ordered(current_page)

    respond_to do |format|
      format.atom
    end
  end
end
