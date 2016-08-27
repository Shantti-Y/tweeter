require 'test_helper'

class TweetsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @tweet = tweets(:hello)
  end

  test "should post create with log in" do
    log_in_as(@user)
    assert_difference 'Tweet.count', 1 do
      post tweets_path, params: { tweet: { content: "Example tweet!" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'
  end

  test "should not post create without log in" do
    assert_no_difference 'Tweet.count' do
      post tweets_path, params: { tweet: { content: "Example tweet!" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

  test "should delete tweet with log in" do
    log_in_as(@user)
    assert_difference 'Tweet.count', -1 do
      delete tweet_path(@tweet)
    end
    assert_redirected_to root_url
  end

  test "should not delete tweet by wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Tweet.count' do
      delete tweet_path(@tweet)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
  end

end
