class FollowsController < ApplicationController
  before_action :logged_in_user
  before_action :url_log, only: [:following, :followers]

  def following
    session.delete(:follow_user_id)
    @user = User.find(params[:id])
    session[:follow_user_id] = @user.id
    @follows = @user.following
  end

  def followers
    session.delete(:follow_user_id)
    @user = User.find(params[:id])
    session[:follow_user_id] = @user.id
    @follows = @user.followers
  end

  def create
    @user = User.find(params[:id])
    log_user.follow(@user)
    #This variable should be an instance to be given the user specification to js template.
    @follow = log_user.following.find(params[:id])
      respond_to do |format|
        format.html { redirect_back_to(root_url) }
        format.js { @user = User.find(session[:follow_user_id]) }
      end
  end

  def destroy
    @user = User.find(params[:id])
    #This variable should be an instance to be given the user specification to js template.

    @follow = log_user.following.find(params[:id])
    log_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_back_to(root_url) }
        format.js { @user = User.find(session[:follow_user_id]) }
      end

  end

end
