class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:friend_id])
    @friendship = current_user.request_friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Successfully followed"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end
end
