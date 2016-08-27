require 'test_helper'

class TweetControlTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "Locating tweeter with admin user" do
    log_in_as(@user)
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'
    assert_select '.post-tweet .fa-remove', 20
    assert_select '#tweet-reload'

    # Reloading to get 20 more previous tweets
    get reload_path(count: 20)
    follow_redirect!
    assert_select '.post-tweet', 40

    get user_path(@user)
    assert_select '.post-tweet .fa-remove', 20
    get reload_path(count: 20)
    follow_redirect!
    assert_select '.post-tweet', 40
  end

  test "Locating tweeter with non-admin user" do
    log_in_as(@other_user)
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'

    # Will be edited with more proper method of counting tweets
    assert_select '.post-tweet', 20
    assert_select '.post-tweet .fa-remove', 3
    assert_select '#tweet-reload'

    get user_path(@other_user)
    assert_select '#tweet-reload', 0
  end

end
