class ChatroomController < ApplicationController

  before_action :require_user
  
  def index
    @message = Message.new
    @messages = Message.all
    @users = User.all
  end
end
