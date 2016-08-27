class StaticPagesController < ApplicationController
  before_action :url_log, only: [:home, :about, :help, :contact]

  def home
    session[:tweet_count] = 20 if session[:tweet_count].nil?
    @tweets = Tweet.all.order(:created_at).reverse.take(session[:tweet_count])
    @tweet = Tweet.new()
    @user = log_user
    session.delete(:tweet_count)
  end

  def reload
    session[:tweet_count] = params[:count].to_i + 20
    respond_to do |format|
      format.html { redirect_back_to(root_url) }
      format.js {
        case session[:forwarding_url]
        when root_url
          @user = log_user
          @tweets = Tweet.all.order(:created_at).reverse.take(session[:tweet_count])
        when user_url(params[:id])
          @user = User.find(params[:id])
          @tweets = @user.tweets.order(:created_at).reverse.take(session[:tweet_count])
        end
        session.delete(:tweet_count)
      }
    end
  end

  def about
  end

  def help
  end

  def contact
  end
  
end
