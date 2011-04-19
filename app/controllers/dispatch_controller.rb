class DispatchController < PublicController
  def show
    if current_page.comment?
      current_page.comments.create({ :author_ip => request.ip }.merge(params[:comment]))
      redirect_to current_page.permalink
    else
      render :text => Liquify.invoke(current_page.template.content)
    end
  end
end
