class UserMailer < Devise::Mailer
  default from: 'james@foxcollis.com'

  def welcome_email
    @user = params[:user]
    @url = 'https://tranquil-forest-27711.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Grandmazon!')
  end
end
