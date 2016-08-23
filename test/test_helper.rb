ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def log_out_test
    session.delete(:user_id)
  end

  class ActionDispatch::IntegrationTest

    def log_in_as(user, password: 'password', insert_cookie: '1')
      post login_path, params: { session: { email_num: user.email_num,
                                            password: password,
                                            insert_cookie: insert_cookie }}
    end
  end
  # Add more helper methods to be used by all tests here...
end
