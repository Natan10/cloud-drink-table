class UserMailer < ApplicationMailer
  default from: 'notifications@system.com'

  def user_created_email
    @name = params[:name]
    @email = params[:email]
    mail(to: @email, subject: 'Your user has been created! ')
  end
end
