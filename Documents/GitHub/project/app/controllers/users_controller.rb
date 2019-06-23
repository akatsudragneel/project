class UsersController < ApplicationController # controller for handling users.
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index                                       #if user is permitted by admin then only it gets access
    if params[:approved] == "false"
      @users = User.where(approved: false).includes(:role)
    else
      @users = User.all.where.not(id: current_user.id).includes(:role)
    end
  end

  def show                        
    @joined_on = @user.created_at.to_formatted_s(:short)  # show details of particular user   
    if @user.current_sign_in_at
      @last_login = @user.current_sign_in_at.to_formatted_s(:short)
    else
      @last_login = "never"
    end
    render :layout => false
  end

  def new
  end

  def edit  
    render :layout => false
  end

  def create                   #for creating new user 
    respond_to do |format|
      if verify_recaptcha(model: @user) && @user.save
        #User.invite!(:email => @user.email, :name=> @user.name) 
        format.html { redirect_to users_path, flash[:notice] => 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update                          #for updating the details of an existing user
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    if @user == current_user # Current user can't edit his profile details i.e. Roles
      successfully_updated = @user.update(user_params_restricted)
    else   
      successfully_updated = if needs_password?(@user, user_params)
                               @user.update(user_params)
                             else
                               @user.update_without_password(user_params)
                             end  
    end
      respond_to do |format|
      if successfully_updated
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.js  
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def unapproved
    user = User.find(params[:id])
    user.update(approved: params[:approved])
  end

  def destroy  
  @user = User.find_by_id(params[:id])
    if !! @user                       # deleting user permanently
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
      format.js 
    end
  end
  end

  protected
    def needs_password?(user, params)
      params[:password].present?
    end
    
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :role_id, :approved)
    end
    def user_params_restricted
      params.require(:user).permit(:email, :password, :password_confirmation,:name)
    end 
end
