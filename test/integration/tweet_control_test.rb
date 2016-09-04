require 'test_helper'

class TweetControlTest < ActionDispatch::IntegrationTest

  def setup
    @first_user = users(:michael)
    # first_user has 24 tweets
    @second_user = users(:archer)
    # second_user has 3 tweets
    @third_user = users(:lana)
    # third_user has 20 tweets
    Relationship.destroy_all
  end

  test "Locating tweeter with admin user" do
    log_in_as(@first_user)
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'

    # Reloading to get 20 more previous tweets
    assert_select '.list-tweet', 20
    assert_select '.list-tweet .fa-remove', 20
    assert_select '#tweet-reload'

    get reload_path(count: 20)
    follow_redirect!
    assert_select '.list-tweet', 24
    assert_select '.list-tweet .fa-remove', 24
    assert_select '#tweet-reload', 0

    # Reloading to get 20 more previous tweets from following users
    @first_user.follow(@third_user)
    get root_path
    assert_select '.list-tweet', 20
    assert_select '.list-tweet .fa-remove', 20
    assert_select '#tweet-reload'

    get reload_path(count: 20)
    follow_redirect!
    assert_select '.list-tweet', 40
    assert_select '.list-tweet .fa-remove', 40
    assert_select '#tweet-reload'

    get reload_path(count: 40)
    follow_redirect!
    assert_select '.list-tweet', 44
    assert_select '.list-tweet .fa-remove', 44
    assert_select '#tweet-reload', 0

    # Locating own user path
    get user_path(@first_user)
    assert_select '.list-tweet', 20
    assert_select '.list-tweet .fa-remove', 20
    assert_select '#tweet-reload'

    get reload_path(count: 20)
    follow_redirect!
    assert_select '.list-tweet', 24
    assert_select '.list-tweet .fa-remove', 24
    assert_select '#tweet-reload', 0
  end

  test "Locating tweeter with non-admin user" do
    log_in_as(@second_user)
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'

    # Reloading to get 20 more previous tweets
    assert_select '.list-tweet', 3
    assert_select '.list-tweet .fa-remove', 3
    assert_select '#tweet-reload', 0

    # Reloading to get 20 more previous tweets from following users
    @second_user.follow(@third_user)
    get root_path
    assert_select '.list-tweet', 20
    assert_select '#tweet-reload'

    get reload_path(count: 20)
    follow_redirect!
    assert_select '.list-tweet', 23
    assert_select '.list-tweet .fa-remove', 3
    assert_select '#tweet-reload', 0

    # Locating own user path
    get user_path(@second_user)
    assert_select '.list-tweet', 3
    assert_select '.list-tweet .fa-remove', 3
    assert_select '#tweet-reload', 0
  end

end
