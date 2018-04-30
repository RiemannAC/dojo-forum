class FriendshipsController < ApplicationController
  before_action :set_user, only: [:accept, :ignore]
  before_action :set_friendship, only: [:accept, :ignore]

  def create
    @user = User.find(params[:friend_id])
    @friendship = current_user.request_friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friendship request successfully created！"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def accept
    if @friendship.update(status: true)
      flash[:notice] = "Now you are friends！"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def ignore
    if @friendship.destroy
      flash[:notice] = "Friendship request successfully deleted！"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_friendship
    @friendship = current_user.inverse_request_friendships.find_by(user_id: params[:id])
  end

end
