class FollowsController < ApplicationController
  before_action :logged_in_user
  before_action :url_log, only: [:following, :followers]

  def following
    @user = User.find(params[:id])
    @follows = @user.following
  end

  def followers
    @user = User.find(params[:id])
    @follows = @user.followers
  end

  def create
    @user = User.find(params[:id])
    log_user.follow(@user)
    #This variable should be an instance to be given the user specification to js template.
    @follow = log_user.following.find(params[:id])
      respond_to do |format|
        format.html { redirect_back_to(root_url) }
        format.js {  }
      end
  end

  def destroy
    @user = User.find(params[:id])
    #This variable should be an instance to be given the user specification to js template.

    @follow = log_user.following.find(params[:id])
    log_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_back_to(root_url) }
        format.js { }
      end

  end

end
