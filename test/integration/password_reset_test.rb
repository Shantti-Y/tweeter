require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    ActionMailer::Base.deliveries.clear
  end

  test "password reset" do
    get password_reset_path
    assert_response :success

    # Invalid email or number
    post password_reset_path, params: { password_reset: { email_num: "wrong user" } }
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_template 'account_managements/reset_new'

    ActionMailer::Base.deliveries.clear

    post password_reset_path, params: { password_reset: { email_num: @user.email_num } }

    # In the case of emergency that model method does not work
    @user.create_reset_digest

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-info'
    assert_select 'div#login'

    # Invalid access without activated user
    @user.toggle!(:activated)
    get password_reset_confirmation_path(id: @user.reset_token, email_num: @user.email_num)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'
    @user.toggle!(:activated)

    # Denied to access with wrong email or number
    get password_reset_confirmation_path(id: @user.reset_token, email_num: "wrong user")
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'

    # Denied to access with wrong token
    get password_reset_confirmation_path(id: "Invalid token", email_num: @user.email_num)
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-danger'
    assert_select 'div#login'

    # Denied to access in expired date
    @user.update_attribute(:reseted_at, 3.weeks.ago)
    get password_reset_confirmation_path(id: @user.reset_token, email_num: @user.email_num)
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.update_attribute(:reseted_at, Time.zone.now)

    get password_reset_confirmation_path(id: @user.reset_token, email_num: @user.email_num)
    assert_response :success

    patch password_reset_confirmation_path(id: @user.reset_token), params: { email_num: @user.email_num,
                                                                         user: { password: 'password',
                                                                                 password_confirmation: 'password'} }

    # In the case of emergency that model method does not work
    @user.delete_reset_digest

    assert @user.reset_token.nil?
    assert @user.reset_digest.nil?
    assert @user.reseted_at.nil?

    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.flash-success'

=begin
  記録1：password_reset_confirmationへのpatchリクエストにおいて、update_attributesメソッドがNilclassに対して定義されていないというエラーが発生した。
        patchリクエストでパラメータは確かに送ったはずなのにNilClassがコントローラに対して渡されていたのだ。
       原因は、userparamsにおいて外部リクエストから受けいけられるusesパラメータ中のキーがpasswordとpassword_confirmationのみであったにもかかわらず、
       email_numキーをusersパラメータに含んでリクエストを送信してしまったことである。
       これに対して、email_numキーをusersパラメータ内から外し、別のパラメータとして送信する事でリクエストの送信に成功した。

  記録2:リクエスト送信アサーションにおいて、password_reset_confirmationへのgetリクエストを送信しても、templateのｎ内容が[]つまりブランクになって返されていた。
      　 原因は、password_resetへのpostリクエストが送信成功する際にコントローラ内で動かすはずのreset_token生成メソッドが発動していなかったことだと考えられる。
        よって、testファイル内に直接メソッドを記入することでやや強引にreset_token(とreset_digest)を生成する事とした。
        このほかにも、userモデルテスト内で1部のメソッドがモデル内で発動しない事案が複数確認されている。今後同じトラブルが起きた時は上記と同様の方法で対処する。
=end

  end
end
