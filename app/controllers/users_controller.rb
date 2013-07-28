class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :followers, :following]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: [:destroy, :staff_input, :recommendations]
  
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
    @user = User.find(params[:id])
  end

  def courses
    @user = current_user
  end

  def recommendations
    @title = "Submit recommendations"
    @user = User.find(params[:id])
    render 'recommendations'
  end

  def staff_input
    @title = "Input grades"
    @user = User.find(params[:id])
    render 'staff_input'
  end

  def input_grades
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:success] = "Grades updated."
    redirect_to @user
  end

  def input_recommendations
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:success] = "Recommendations submitted."
    redirect_to @user
  end

  def update
    if params[:user].has_key?("email")
      if @user.update_attributes(params[:user])
        # Handle a successful update.
        flash[:success] = "Profile updated."
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    elsif params[:user].has_key?("course1")
      if @user.update_attributes(params[:user])
        # Handle a successful update.
        flash[:success] = "Course list updated."
        sign_in @user
        redirect_to(courses_path)
      else
        render 'courses'
      end
    elsif params[:user].has_key?("grade1")
      if @user.update_attributes(params[:id])
        # Handle a successful update.
        flash[:success] = "Grades updated."
        sign_in @user
        redirect_to(root_path)
      else
        render 'input'
      end
    elsif params[:user].has_key?("rec1")
      if @user.update_attributes(params[:id])
        # Handle a successful update.
        flash[:success] = "Recommendations submitted."
        sign_in @user
        redirect_to(recommendations_path)
      else
        render 'recommendations'
      end
    else
      if @user.update_attributes(params[:user])
        # Handle a successful update.
        flash[:success] = "Profile updated."
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    end
  end

  def index
    @users = User.where(site: current_user.site).paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  else
    flash[:error] = "Cannot delete self."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def search
    @user = current_user
    @users = User.search(params[:search],@user.id)
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
