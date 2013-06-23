class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
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
  
  def destroy 
    
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
 
end
