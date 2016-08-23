class SessionsController < ApplicationController

  def create
    user = User.find_by(email_num: params[:session][:email_num])
    if user && user.activated? && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:insert_cookie] == '1' ? cookie_in(user) : cookie_out(user)
      flash[:success] = "Welcome back! #{user.name}"
      redirect_to root_path
    elsif !user.activated?
      flash.now[:danger] = "Account isn't authorized. Please check email to activate."
      render 'static_pages/home'
    else
      flash.now[:danger] = "Invalid email(phone) or password."
      render 'static_pages/home'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
