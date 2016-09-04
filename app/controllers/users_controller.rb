class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :url_log
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    session.delete(:follow_user_id)
    session[:tweet_count] = 20 if session[:tweet_count].nil?
    @user = User.find(params[:id])
    session[:follow_user_id] = @user.id
    @tweets = @user.tweets.order(:created_at).reverse.take(session[:tweet_count])
    @tweet = Tweet.new()
    session.delete(:tweet_count)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Sent verify email. Please check it to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "Welcome to Tweeter!"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email_num, :password, :password_confirmation)
    end

    def correct_user
      logged_in_user
      @user = User.find(params[:id])
      unless @user == log_user
        flash[:danger] = "Prohibited to access."
        redirect_back_to(root_path)
      end
    end

    def admin_user
      logged_in_user
      user = log_user
      @user = User.find(params[:id])
      unless (user.admin? || @user == user)
        flash[:danger] = "Prohibited to access."
        redirect_back_to(root_path)
      end
    end

end
