class StaticPagesController < ApplicationController

  def home
  	if signed_in?
  		@micropost = current_user.microposts.build
  		@feed_items = current_user.feed.paginate(page: params[:page])
      @announcements = current_user.announcements.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end

  def contact
  end

  def house
    if signed_in?
      @micropost = current_user.microposts.build
      @house_feed = current_user.house_feed.paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end

end
