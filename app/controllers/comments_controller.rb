class CommentsController < ApplicationController
  
  before_action :require_signed_in
  
  def new 
  end
  
  def create
    @comment = current_user.comments.new(comment_params)
    
    if @comment.save
      flash[:notice] = "Comment Added"
      redirect_to post_url(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end
  
  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
