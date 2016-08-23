require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "example_user", email_num: "user@example.com",
                       password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "two users should not have the same name" do
    duplicate_user = @user.dup
    duplicate_user.email_num = "duplicate@example.com"
    @user.save
    assert_not duplicate_user.valid?
  end

  test "name should be saved with translating blank to under-bar" do
    blank_case_name = "example user"
    valid_name_case = @user.name
    @user.name = blank_case_name
    @user.save
    assert_equal valid_name_case, @user.name
  end

  test "name should be saved as lower-case" do
    upper_case_name = "Example_User"
    @user.name = upper_case_name
    @user.save
    assert_equal upper_case_name.downcase, @user.name
  end

  test "email_num should be present" do
    @user.email_num = ""
    assert_not @user.valid?
  end

  test "email_num should not be too long" do
    @user.email_num = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email_num should be unique" do
    duplicate_user = @user.dup
    duplicate_user.name = "Non Example"
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email_num validation should accept valid addresses" do
    valid_addresses = %w[user@example.com
                         michael@yahoo.co.jp
                         USER@foo.com
                         mon_key+oh@foo.com]
    valid_addresses.each do |valid_address|
      @user.email_num = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end
  end

  test "email_num validation should not accept invalid addresses" do
    invalid_addresses = %w[user@example,com
                         michael_yahoo_co_jp
                         user@name.example.
                         mon_key+oh@foo+.com]
    invalid_addresses.each do |invalid_address|
      @user.email_num = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
    end
  end

  test "eail_num should be passed with valid number" do
    valid_numbers = %w[1234567890
                       12345678901]
    valid_numbers.each do |valid_number|
      @user.email_num = valid_number
      assert @user.valid?, "#{valid_number.inspect} should be valid."
    end
  end

  test "eail_num should be passed with invalid number" do
    invalid_numbers = %w[123456789
                         123456789012
                         12cd56g89j]
    invalid_numbers.each do |invalid_number|
      @user.email_num = invalid_number
      assert_not @user.valid?, "#{invalid_number.inspect} should be invalid."
    end
  end

  test "email_num should be saved as lower-case" do
    upper_case_email_num = "Foo@ExAMPle.CoM"
    @user.email_num = upper_case_email_num
    @user.save
    assert_equal upper_case_email_num.downcase, @user.email_num
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should be at least 8 characters" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "password should be exact with confirmation" do
    @user.password_confirmation = "passward"
    assert_not @user.valid?
  end

  test "valid user should have activation_token" do
    @user.save
    assert_not @user.activation_token.nil?
  end

end
