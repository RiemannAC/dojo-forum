class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @posts = @user.posts.are_viewable?(current_user).are_public?
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
