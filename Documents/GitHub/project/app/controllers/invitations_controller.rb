class InvitationsController < ApplicationController # Controller for presenting all the invitations made
  #authorize_resource :class => false
  def index
    if params[:invitation_accepted_at] == nil
      @users = User.where.not(invitation_accepted_at: nil)    
    else
      @users = User.all
    end
  end
end  