require 'magnetism/page_not_found'

class CommentsController < PublicController
  def create
    raise Magnetism::PageNotFound unless current_page.blog_entry? && params[:comment]

    # should check if comments are "closed"
    current_page.comments.create(comment_params)
    redirect_to current_page.permalink
  end

  private
    def comment_params
      {
        :author_ip => request.ip,
        :author_name => 'Anonymous'
      }.merge(params[:comment])
    end
end
