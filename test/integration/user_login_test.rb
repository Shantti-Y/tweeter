require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "Mistaken information for login" do
    post login_path, params: { session: { email_num: "michael@example.com",
                                          password: ""}}
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_template 'static_pages/home'
    assert_select '.flash-danger'
    assert_select 'div#login'

    get root_path
    assert flash.empty?
  end

  test "Valid user logs in and out" do
    post login_path, params: { session: { email_num: @user.email_num,
                                          password: "password" }}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'

    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', logout_path

    delete logout_path

    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div#login'
  end

  test "login with inserting cookie" do
    log_in_as(@user, insert_cookie: '1')
    assert is_logged_in?
    assert_redirected_to root_url
    assert_not cookies['remember_token'].nil?
  end

  test "login without inserting cookie" do
    log_in_as(@user, insert_cookie: '0')
    assert is_logged_in?
    assert_redirected_to root_url
    assert cookies['remember_token'].nil?
  end

end
