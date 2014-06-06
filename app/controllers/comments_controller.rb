class CommentsController < ApplicationController

  before_action :require_signed_in

  def new
    @comment = Comment.new(parent_comment_id: params[:comment_id],
                            post_id: params[:post_id])

  end

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.post_id.nil?
      @comment.post_id = @comment.parent_comment.post_id
    end

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
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
