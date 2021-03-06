# frozen_string_literal: true

module UsersHelper
  def user_invited?(invited_user)
    invited_user.pending_requests.where(requestor_id: current_user.id).empty?
  end

  def display_friend_requests(friendship)
    User.find(friendship.requestor_id).username
  end

  def accept_friend_now(friendship)
    User.find(friendship.requestor_id).id
  end

  def request?(friend)
    !current_user.pending_requests.where(requestor_id: friend.id).empty?
  end

  def link_status(user)
    if current_user != user
      if current_user.friend_requested?(user)
        button_to 'Cancel Request', { controller: 'friendships', action: 'cancel_friend_request', invited_id: user }, method: :post
      elsif current_user.we_are_friends?(user)
        button_to "Delete Friend #{user.username}", { controller: 'friendships', action: 'delete_friend', friend_d: user }, method: :post
      elsif request?(user)
        button_to 'Accept  Request', { controller: 'friendships', friend_o: user.id, action: 'accept_friend' }, method: :post
      else
        button_to "Add Friend #{user.username}", { controller: 'friendships', action: 'send_friend_request', user_id: user }, method: :post
      end
    else
      link_to 'My Settings', edit_user_registration_path(user)
    end
  end

  def tumblr(user)
    image_tag user.avatar.variant(thumbnail: '100') if user.avatar.attached?
  end
end
