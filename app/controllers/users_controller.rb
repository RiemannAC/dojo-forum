class UsersController < ApplicationController
  before_action :set_user, only: [:show, :comments]

  def show
    @posts = @user.posts.are_viewable?(current_user).are_public?
  end

  def comments
    @comments = @user.comments.includes(:post)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
