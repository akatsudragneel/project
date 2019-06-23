class PostsController < ApplicationController # A controller for handling Posts CRUD.
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index # only members of a group and superadmin is allowed to view the post created in that group
    if check_group_is_public
      @post= Post.where(group_id: @group.id).includes(:user)
      @post = @post.paginate(:page => params[:page], :per_page => 2)
    end
  end

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    if check_group_is_public
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      @post.group_id = @group.id
      if @post.save
        flash[:success] = "Post created!"
        redirect_to group_posts_path
      else
        render 'new'
      end
    end
  end

  def show
    if check_group_is_public
      @post = Post.find(params[:id])
    end
  end

  def edit
    render :layout => false
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to group_posts_url, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy 
   if current_user == @post.user
      @post.destroy
      respond_to do |format| 
        format.html { redirect_to group_posts_url, notice: 'Post was successfully destroyed.' }   
      end
    else
      redirect_to groups_url, :flash => { :error => "Post owner can only delete post" }   
    end   
  end

  def vote             # To upvote or downvote the post using Like Button
    if !current_user.liked? @post
      @post.liked_by current_user
    elsif current_user.liked? @post
      @post.unliked_by current_user
    end      
  end  
  
  private
    def post_params
      params.require(:post).permit(:title,:body, :group_id, :user_id)
    end

end
