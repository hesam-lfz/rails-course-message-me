class MessagesController < ApplicationController

  #before_action :set_article, only: [:show, :edit, :update, :destroy]
  #before_action :require_user, except: [:show, :index]
  #before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
  end
  
  def index
    @messages = Message.all    
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
        flash[:notice] = "Message created."
        redirect_to root_path
    else
        render 'new'
    end
  end


  private

  def set_messge    
    @message = Message.find(params['id'])
  end
  
  def message_params
    params.require(:message).permit(:user)
  end

end
