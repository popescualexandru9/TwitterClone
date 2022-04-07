# frozen_string_literal: true

class FriendSerializer < ActiveModel::Serializer
  attributes :id, :follower, :following

  def follower
    object.follower_follows
  end

  def following
    object.following_follows
  end
end
