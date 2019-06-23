class OmniauthCallbacksController < Devise::OmniauthCallbacksController # Only for authenticating users using their facebook or google account
  
  def facebook             
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?          # if user is found then he is logged in otherwise redirected to registration page
      flash.notice = "Account Sccessfully authenticated."
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes # if user is new then registration is done using omniauth
      redirect_to new_user_registration_url
    end 
  end

  def failure
    redirect_to root_path
  end
  
  def google_oauth2
    user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect user
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

end
