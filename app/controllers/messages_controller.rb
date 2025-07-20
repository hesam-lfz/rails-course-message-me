class MessagesController < ApplicationController

  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
  end
  
  def index
    @messages = Message.paginate(page: params[:page], per_page: 5)  
  end

  def new
    @message = Message.new
  end

  def create
    #@message = Message.new(message_params)
    #@message.user = current_user
    @message = current_user.messages.build(message_params)
    if @message.save
      ActionCable.server.broadcast("chatroom_channel", 
        {body: render_message_to_send})      
      flash[:notice] = "Message created."      
    else
      render 'new'
    end
  end

  def update    
    if @message.update(message_params)
      flash[:notice] = "Message updated."
      redirect_to @message
    else
      render 'edit'
    end
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  private

  def set_message    
    @message = Message.find(params['id'])
  end
  
  def message_params
    params.require(:message).permit(:body)
  end

  def render_message_to_send 
    render(partial: 'message', locals: {message: @message})
  end
end
