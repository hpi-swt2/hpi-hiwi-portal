class UsersMailer < ActionMailer::Base
  default from: 'hpi.hiwi.portal@gmail.com'

  def new_password_mail(password, user)
    @password = password
    @user = user
    mail to: @user.email, subject: t("users.messages.your_new_password")
  end
end
