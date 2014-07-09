class PostsController < ApplicationController

  before_action :require_signed_in, only: [:new, :create, :edit, :update]

  helper_method :permitted_to_edit?

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params.merge({sub_id: params[:sub_id]}))

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end

  end

  def edit
    @post = Post.find(params[:id])
    require_submitter_or_moderator
  end

  def update
    @post = Post.find(params[:id])
    require_submitter_or_moderator

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end


  def show
    @post = Post.find(params[:id])
    @all_comments = Comment.where(post_id: @post.id).includes(:submitter, :votes)
    @all_comments_hash = hashify_comments(@all_comments)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end

  def require_submitter_or_moderator
    unless permitted_to_edit?(@post)
      flash[:notice] = "You cannot edit this post"
      redirect_to post_url(@post)
    end
  end

  def permitted_to_edit?(post)
    post.submitter == current_user || post.sub.moderator == current_user
  end

  def hashify_comments(comments)
    comments_hash = Hash.new { |h, k| h[k] = Array.new }
    comments.each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end

    comments_hash.each do |parent, comments|
      comments.sort! {|x,y| y.sum_votes <=> x.sum_votes }
    end
    comments_hash
  end


end
