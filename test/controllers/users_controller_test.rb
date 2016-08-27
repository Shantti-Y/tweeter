require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
  end

  test "enable to access edit page from show with correct user" do
    log_in_as(@other_user)
    get user_path(@other_user)
    assert_response :success
    assert_select 'a[href=?]', edit_user_path(@other_user)
    assert_select 'a.delete[href=?]', user_path(@other_user)

    get user_path(@user)
    assert_response :success
    assert_select 'a[href=?]', edit_user_path(@user), 0
    assert_select 'a.delete[href=?]', user_path(@user), 0
  end

  test "enable to access delete other user by admin user" do
    log_in_as(@user)
    get user_path(@other_user)
    assert_response :success
    assert_select 'a[href=?]', edit_user_path(@other_user), 0
    assert_select 'a.delete[href=?]', user_path(@other_user)
  end

  test "enable to access edit page with log in" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_response :success
  end

  test "unable to access edit page without log in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

  test "unable to access edit page by wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
  end

  test "enable to patch user with log in" do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email_num: @user.email_num,
                                              password: 'password',
                                              password_confirmation: 'password'}}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select '.flash-success'
  end

  test "unable to patch user without log in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email_num: @user.email_num,
                                              password: 'password',
                                              password_confirmation: 'password'}}
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

  test "unable to patch another user by wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email_num: @user.email_num,
                                              password: 'password',
                                              password_confirmation: 'password'}}
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
  end

  test "enable to delete user page with log in" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert is_logged_in?
    assert_redirected_to root_url
  end

  test "unable to delete user page without log in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
  end

  test "enable to delete user page by admin user" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert is_logged_in?
    assert_redirected_to root_url
  end

  test "unable to delete user page by wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
  end

end
