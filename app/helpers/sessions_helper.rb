module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def cookie_in(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def cookie_out(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_user
    if user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?("remember", cookies[:remember_token])
        log_in(user)
        @log_user = user
      end
    elsif user_id = session[:user_id]
      @log_user || User.find_by(id: session[:user_id])
    end
  end

  def log_user?(user)
    user == log_user
  end

  def logged_in?
    !log_user.nil?
  end

  def log_out
    cookie_out(log_user)
    session.delete(:user_id)
    @log_user = nil
  end

  def store_location
    session.delete(:forwarding_url)
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_to(default)
    redirect_to session[:forwarding_url] || default
    session.delete(:forwarding_url)
  end

end
