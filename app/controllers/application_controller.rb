class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def url_log
      store_location
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Unable to access. Please log in."
        redirect_to root_path
      end
    end

    def change_digest
      if logged_in?
        user = User.find_by(id: session[:user_id])
        if cookies && user.authenticated?("remember", cookies[:remember_token])
          cookie_in(user)
        end
      end
    end

end
