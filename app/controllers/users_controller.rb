class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def show
  	@user = User.find(params[:id])
  end

  def new
    unless signed_in?
  	  @user = User.new
    else
      redirect_to(root_path)
    end
  end

  def create
    unless signed_in?
  	  @user = User.new(params[:user])
  	  if @user.save
        sign_in @user
  		  flash[:success] = "Welcome to the HSYLC Conference Tool!"
  		  redirect_to @user
  	  else
  		  render 'new'
  	  end
    else
      redirect_to(root_path)
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  else
    flash[:error] = "Cannot delete self."
    redirect_to users_url
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
