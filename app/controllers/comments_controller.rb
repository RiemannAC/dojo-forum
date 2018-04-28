class CommentsController < ApplicationController
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post)
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      redirect_to post_path(@post)
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
