class UsersController < ApplicationController
  before_action :set_user, only: [:show, :comments, :edit, :update, :drafts, :collections, :friends]

  def show
    @posts = @user.posts.are_viewable?(current_user).are_public?
  end

  def comments
    @comments = @user.comments.includes(:post)
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def drafts
    @drafts = @user.posts.where(status: "draft")
  end

  def collections
    @collections = @user.collected_posts.includes(:collected_users)
  end

  def friends
    @request_friends = @user.request_friends
    @inverse_request_friends = @user.inverse_request_friends
    @friends = @user.all_friends
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

end
