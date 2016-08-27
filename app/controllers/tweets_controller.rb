class TweetsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_tweet, only: [:edit, :update, :destroy]

  def create
    @tweet = log_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = "Tweeted!"
      redirect_back_to(root_url)
    else
      flash[:danger] = "Blank Tweet"
      redirect_back_to(root_url)
    end
  end

  def destroy
    @tweet.destroy
    redirect_back_to(root_url)
  end

  private

    def tweet_params
      params.require(:tweet).permit(:content)
    end

    def correct_tweet
      @tweet = Tweet.find(params[:id])
      unless @tweet.user_id == log_user.id
        flash[:danger] = "Prohibited to access"
        redirect_back_to(root_path)
      end
    end

end
