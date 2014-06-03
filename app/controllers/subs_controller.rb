class SubsController < ApplicationController
  
  helper_method :sub_belongs_to
  
  before_action :require_moderator, only: [:edit, :update]
  
  before_action :require_signed_in, only: [:new, :create, :edit, :update]
  
  def new
    @sub = Sub.new
  end
  
  def create
    @sub = current_user.subs.new(sub_params)
    
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end     
  end
  
  def index
    @subs = Sub.all
  end
  
  def show
    @sub = Sub.find(params[:id])
  end
  
  def edit
    @sub = Sub.find(params[:id])
  end
  
  def update
    @sub = Sub.find(params[:id])
    
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end
  
  private 
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
  
  def require_moderator
    unless sub_belongs_to(current_user)
      flash[:notice] = "Only Moderator can edit sub"
      redirect_to sub_url(params[:id]) 
    end
  end
  
  def sub_belongs_to(user)
    Sub.find(params[:id]).moderator == user
  end
end
