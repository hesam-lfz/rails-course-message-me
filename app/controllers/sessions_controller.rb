class SessionsController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
        
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)    
    if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:notice] = "Logged in #{user.username}."
        redirect_to root_path
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

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end


end
