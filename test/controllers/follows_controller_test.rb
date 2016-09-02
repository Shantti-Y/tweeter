require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should get following" do
    log_in_as(@user)
    get following_path(@user)
    assert_response :success
  end

  test "should not get following without log in" do
    get following_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

  test "should get followers" do
    log_in_as(@user)
    get followers_path(@user)
    assert_response :success
  end

  test "should not get followers without log in" do
    get following_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

end
