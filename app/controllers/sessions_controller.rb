class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by_credentials(user_params)
    
    if @user.nil?
      flash.now[:errors] = "Wrong username or password"
      render :new
    else
      login!(@user)
      redirect_to root_url
    end
  end
  
  def destroy
    return nil if current_user.nil?
    current_user.reset_session_token!
    session[:token] = nil
    redirect_to new_session_url
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
