class PostsController < ApplicationController
  def index
    @categories = Category.all
    @posts = Post.page(params[:page]).per(10)
  end
end
