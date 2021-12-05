class FriendshipsController < ApplicationController
  def create
    
    friend=User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice]="#{friend.email} has been added to your friends list"
      redirect_to my_friends_path
    end
  
  end

  def destroy
    friend=User.find(params[:id])

    friendship=Friendship.where(user_id: current_user.id,friend_id: friend.id).first
    friendship.destroy

    flash[:notice]="#{friend.email} has been removed from your friends list"
    redirect_to my_friends_path

  end
end
