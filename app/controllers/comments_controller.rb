require 'magnetism/page_not_found'

class CommentsController < PublicController
  def create
    raise Magnetism::PageNotFound unless current_page.blog_entry? && params[:comment]

    # should check if comments are "closed"
    current_page.comments.create(params[:comment])
    redirect_to current_page.permalink
  end
end
