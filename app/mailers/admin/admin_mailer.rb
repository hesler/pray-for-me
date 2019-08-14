class Admin::AdminMailer < ApplicationMailer
  def invitation_mail(email, token)
    @token = token
    @email = email
    mail(to: @email, subject: 'You have been invited to admin panel on prayforme.com')
  end
end
