require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @first_user = users(:michael)
    @second_user = users(:archer)
    @third_user = users(:lana)
    log_in_as(@first_user)
  end

  test "following page" do
    get following_path(@first_user)
    assert_not @first_user.following.empty?
    assert_match @first_user.following.count.to_s, response.body
    @first_user.following.each do |follow|
      assert_select 'a[href=?]', user_path(follow)
    end
  end

  test "followers page" do
    get followers_path(@first_user)
    assert_not @first_user.followers.empty?
    assert_match @first_user.followers.count.to_s, response.body
    @first_user.followers.each do |follow|
      assert_select 'a[href=?]', user_path(follow)
    end
  end

  test "should follow in a standard way" do
    assert_difference '@first_user.following.count', 1 do
      post follows_path, params: { id: @second_user.id }
    end

  end

  test "should follow with ajax" do

    get user_path(@second_user)
    assert_difference '@first_user.following.count', 1 do
      post follows_path, xhr: true, params: { id: @second_user.id }
    end
    @first_user.follow(@second_user)

    get following_path(@second_user)
    assert_difference '@first_user.following.count', 1 do
      post follows_path, xhr: true, params: { id: @second_user.id }
    end
    @first_user.follow(@second_user)


    get followers_path(@second_user)
    assert_difference '@first_user.following.count', 1 do
      post follows_path, xhr: true, params: { id: @second_user.id }
    end


  end

  test "should unfollow in a standard way" do
    assert_difference '@first_user.following.count', -1 do
      delete follow_path(@third_user)
    end
  end

  test "should unfollow with ajax" do

    get user_path(@third_user)
    assert_difference '@first_user.following.count', -1 do
      delete follow_path(@third_user), xhr: true
    end
    @first_user.follow(@third_user)

    get following_path(@third_user)
    assert_difference '@first_user.following.count', -1 do
      delete follow_path(@third_user), xhr: true
    end
    @first_user.follow(@third_user)

    get followers_path(@third_user)
    assert_difference '@first_user.following.count', -1 do
      delete follow_path(@third_user), xhr: true
    end

  end

end
