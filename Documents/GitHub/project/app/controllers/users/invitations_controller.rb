class Users::InvitationsController < Devise::InvitationsController #Inviting user using Devise
  authorize_resource :class => false, :only => :new
end