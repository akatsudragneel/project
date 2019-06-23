class CommentsController < ApplicationController #Controller for handling CRUD for comments
  
  before_action :find_commentable # First a comment is checked whether Comment is done for Post or a Comment
  load_and_authorize_resource

  def create # For creating New Comment
    if check_group_is_public # Checking Authenticity of user for posting that comment
      @post = @group.posts.find(params[:post_id])
      if @commentable # If this is not nil that that means comment to be created is a reply
        @comment = @commentable.comments.new comment_params
      else
        @comment = @post.comments.new comment_params
      end
      @comment.name = current_user.name # Assigning present user as the commentor of that comment
      if @comment.save!
        redirect_to :back, notice: 'Your comment was successfully posted!'
      else
        redirect_to :back, notice: "Your comment wasn't posted!"
      end
    end
  end

  def new
    @comment = Comment.new
  end

  def destroy
    if check_group_is_public
      @post = @group.posts.find(params[:post_id])
      @comment = Comment.find(params[:id]) 
      @comment.destroy
      redirect_to group_post_path(@group,@post)
    end
  end

  def edit
    if check_group_is_public
      @post = @group.posts.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
    end
    render :layout => false
  end  

  def update
    if check_group_is_public
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
      if @comment.update(comment_params)
        redirect_to group_post_path(@group,@post)
      else
        render 'edit'
      end
    end
  end

  private
    
    def comment_params
      params.require(:comment).permit(:name,:body,:post_id,:group_id,:id)
    end
    
    def find_commentable
      @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
    end
end
