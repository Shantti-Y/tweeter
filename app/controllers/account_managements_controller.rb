class AccountManagementsController < ApplicationController
  before_action :get_user, only: [:reset_edit, :reset_update]
  before_action :valid_user, only: [:reset_update]

  def activation_create
    user = User.find_by(email_num: params[:email_num])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = "Welcome to Tweeter! Enjoy your time."
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_path
    end
  end

  def reset_new

  end

  def reset_create
    @user = User.find_by(email_num: params[:password_reset][:email_num])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Sent verify email. Please check it to edit your password."
      redirect_to root_url
    else
      flash.now[:danger] = "Could not verify your account. Please try again."
      render 'reset_new'
    end
  end

  def reset_edit
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      flash[:danger] = "Invalid reset link"
      redirect_to root_url
    end
  end

  def reset_update
    if @user.update_attributes(user_params)
      flash[:success] = "Reset password complete"
      log_in(@user)
      redirect_to root_path
    else
      render 'reset_edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email_num: params[:email_num])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

end
