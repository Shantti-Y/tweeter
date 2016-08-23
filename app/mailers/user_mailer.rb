class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email_num, subject: "Please verify your email(or phone number)."
  end

  def password_reset(user)
    @user = user
    mail to: user.email_num, subject: "Reset your Tweeter password"
  end
end
