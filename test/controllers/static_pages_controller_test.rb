require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user =users(:michael)
  end

  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get index page with log in" do
    log_in_as(@user)
    get root_url
    assert_select 'div#user-index'
  end

  test "should get login page without log in" do
    get root_url
    assert_select 'div#login'
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get help" do
    get help_url
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_response :success
  end

end
