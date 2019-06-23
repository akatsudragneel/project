class UserMailer < ApplicationMailer
  layout 'mailer'

  def send_admin_mail(user)    # sends mail to admin informing that given user has accepted his invitation
    @user = user
    @admin = User.find(@user.invited_by_id)
    mail(:to => @admin.email , :from => @user.email, :subject =>"Invitation accepted" )
  end

end
