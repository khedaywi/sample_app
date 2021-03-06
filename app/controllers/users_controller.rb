class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy] 
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :avoid_destroy_myself, :only => :destroy
  
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end
  
  def create
    if signed_in?
      redirect_to root_url
    else
      @user = User.new(user_params)    
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        flash[:error] = "You fucked up big time!"
        render 'new'
      end
    end
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "We updated your profile!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def following
    if signed_in?
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to signin_path
    end
  end

  def followers
    if signed_in?
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to signin_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
    
    # Before actions....
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def avoid_destroy_myself
      @user = User.find(params[:id])
      redirect_to users_path, :notice => "You can not destroy yourself" unless !current_user?(@user)
    end
    
end
