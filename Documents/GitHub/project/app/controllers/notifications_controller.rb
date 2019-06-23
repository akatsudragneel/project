class NotificationsController < ApplicationController
 
  skip_before_action :verify_authenticity_token
 
  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '2282224592', to: '+918802329460', body: 'Thanks for signing for demo_project. Glad to have you :) -Akash', media_url: 'http://linode.rabasa.com/yoda.gif', status_callback: request.base_url + '/twilio/status'

    
    render plain: message.status

  end
 
end