class UserMailer < ApplicationMailer
  default from: 'james@foxcollis.com'

  def welcome_email
    @user = params[:user]
    @url = 'https://localhost:3000/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Grandmazon!')
  end
end
