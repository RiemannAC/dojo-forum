class UsersController < ApplicationController
  before_action :set_user, only: [:show, :comments, :update, :drafts, :collections, :friends]

  def show
    if @user == current_user || current_user.admin?
      @posts = @user.posts.are_viewable?(current_user).are_public?.order(created_at: :desc)
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def comments
    if @user == current_user || current_user.admin?
      @comments = @user.comments.order(created_at: :desc).includes(:post)
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    if @user == current_user || current_user.admin?
      @user = User.find(params[:id])
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @user == current_user || current_user.admin?
      @user.update(user_params)
      redirect_to user_path(@user)
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def drafts
    if @user == current_user || current_user.admin?
      @drafts = @user.posts.where(status: "draft")
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def collections
    if @user == current_user || current_user.admin?
      @collections = @user.collected_posts.order("collections.created_at desc").includes(:collected_users)
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  def friends
    if @user == current_user || current_user.admin?
      @request_friends = @user.request_friends
      @inverse_request_friends = @user.inverse_request_friends
      @friends = @user.all_friends
    else
      flash[:alert] = "Not Allow!"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

end
