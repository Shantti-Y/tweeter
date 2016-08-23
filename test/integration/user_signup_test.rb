require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "Invalid information for sign up" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "a" * 51,
                                          email_num: "user@example,com",
                                          password: "foo",
                                          password_confirmation: "bar" }}
    end

    assert_template 'users/new'
    assert_select 'div#error-explanation'
    assert_select 'div#error-explanation > ul > li', 4
  end

  test "Valid information for sign up" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "example_user",
                                          email_num: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" }}
    end
    user = assigns(:user)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not user.activated?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-info'
    assert_select 'div#login'

    # Unable to login without activation
    log_in_as(user)
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_template 'static_pages/home'
    assert_select '.flash-danger'
    assert_select 'div#login'

    # Invalid activation token
    get account_activation_path(id: "invalid", email_num: user.email_num)
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'

    # Invalid email_num
    get account_activation_path(id: user.activation_token, email_num: "Example@com")
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'

    get account_activation_path(id: user.activation_token, email_num: user.email_num)
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    follow_redirect!
    assert_select '.flash-success'
  end
end
