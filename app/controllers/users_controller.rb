class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def show
    #@articles = @user.articles
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)        
    if @user.save
        # @user.toggle!(:admin) if @user.username == 'admin'
        # render plain: @user.inspect
        # redirect_to article_path(@user)
        session[:user_id] = @user.id
        flash[:notice] = "User #{@user.username} created."
        redirect_to articles_path
    else
        render 'new'
    end
  end

  def edit
  end

  def update    
    if @user.update(user_params)
      flash[:notice] = "User updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    @user.articles do |article|

    end
    flash[:notice] = "Profile and its articles deleted"
    redirect_to articles_path
  end


  private

  def set_user    
    @user = User.find(params['id'])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "Can only edit or delete your own profile"
            redirect_to @user
        end
    end

end
