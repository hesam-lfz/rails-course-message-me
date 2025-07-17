class SessionsController < ApplicationController

  
  def new
    
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:notice] = "Logged in #{user.username}."
        redirect_to user
    else
        flash.now[:alert] = 'Wrong login!'
        render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out."
    redirect_to root_path
  end
  
  private


end
