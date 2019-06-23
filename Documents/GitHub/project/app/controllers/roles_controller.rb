class RolesController < ApplicationController #3 roles are defined at the time of creation,These are Superadmin,Admin and Regular User
  before_filter :authenticate_user! 
  

  # Uncomment to have CRUD on roles


  # def index
  #   @roles = Role.all
  # end

  # def show
  #   if @role.users.length == 0
  #     @assosciated_users = "None"
  #   else
  #     @assosciated_users = @role.users.map(&:name).join(", ")
  #   end
  # end

  # def new
  # end

  # def edit
  # end

  # def create
  #   respond_to do |format|
  #     if @role.save
  #       format.html { redirect_to @role, notice: 'Role was successfully created.' }
  #       format.json { render :show, status: :created, location: @role }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @role.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def update
  #   respond_to do |format|
  #     if @role.update(role_params)
  #       format.html { redirect_to @role, notice: 'Role was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @role }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @role.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @role.destroy
  #   respond_to do |format|
  #     format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def role_params
      params.require(:role).permit(:name, :description)
    end
end
