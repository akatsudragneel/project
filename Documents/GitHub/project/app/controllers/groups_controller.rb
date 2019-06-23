class GroupsController < ApplicationController # Controller for handling CRUD in groups
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @member = Membership.where(user_id: current_user.id)
    if current_user.superadmin? # only superadmin is allowed to see all the created groups
      @groups = Group.all
    else 
      @groups = current_user.groups # others can see only their created group or groups whose they are members
    end
  end

  def new  
    @group = Group.new
    @users = User.all
    @memberships = @users.map{ |user| @group.memberships.build({user_id: user.id}) }
  end

  def show   #Modal content for show is given by this
    @members = Membership.all 
    @users = User.all
    render :layout => false
  end
     
  def create   # First a group is created and then members in it are addded       
    @user = User.find_by_id(:user_id)
    @group = Group.new(group_params)
    @group.created_by = current_user.name 
    respond_to do |format|
      if @group.save
        @group.users << current_user
        format.html { redirect_to groups_url, notice: 'Group was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update       #This is to change the group membership after the group is created.
    respond_to do |format|
    @group = Group.find(params[:group_id])  
    user = User.find(params[:user_id]) 
    @group.users << user unless @group.users.include? user 
      format.html { redirect_to add_members_group_path(@group), notice: 'Members successfully Updated.' }
    end
  end

  def remove_member # this will remove members from the group member list after the creation of the group is done
    @group = Group.find(params[:group_id])  
    user = User.find(params[:user_id])
    respond_to do |format|
      member = Membership.where(user_id:user.id,group_id:@group.id)
      Membership.delete(member)
      format.html { redirect_to add_members_group_path(@group), notice: 'Member was successfully destroyed.' }
    end
  end

  def add_members
    @users = User.all 
  end

  def destroy # for destroying complete group
    @user = User.find_by_id(params[:id])
    if @group.nil? 
      redirect_to root_path
    end  
    respond_to do |format|
      if @group.destroy
        format.html {redirect_to groups_url, notice: 'Group was successfully destroyed.'}
        format.js 
      else
        format.html {redirect_to groups_url, notice: "Group can't be destroyed."}  
      end
    end
  end

  private
    def group_params
      params.require(:group).permit(:name,:desc,:created_by,:is_public,:user_id,memberships_attributes: [:user_id,[]])
    end
end

