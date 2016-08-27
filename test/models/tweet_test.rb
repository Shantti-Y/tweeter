require 'test_helper'

class TweetTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @tweet = Tweet.new(content: "Example hello!", user_id: @user.id)
  end

  test "tweet should be valid" do
    assert @tweet.valid?
  end

  test "content should be present" do
    @tweet.content = ""
    assert_not @tweet.valid?
  end

  test "content should have less than 140 characters" do
    @tweet.content = "a" * 141
    assert_not @tweet.valid?
  end

  test "user_id should be present" do
    @tweet.user_id = nil
    assert_not @tweet.valid?
  end

  test "tweet should be destroyed when the relative user does not exist" do
    tweet_num = Tweet.count
    @tweet.save
    @user.destroy
    assert_not_equal tweet_num, Tweet.count
  end

end
