class FeedsController < ApplicationController
  def index
    @user_count = User.all.count
    @post_count = Post.are_public?.count
    @comment_count = Comment.all.count
    @users = User.select(:id, :name, :comments_count).order(comments_count: :desc).limit(10)
    @posts = Post.select(:id, :title, :comments_count, :updated_at).are_public?.order(comments_count: :desc).limit(10)
  end
end
