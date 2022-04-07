# frozen_string_literal: true

class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user, :tweet

  def user
    object.user
  end

  def tweet
    object.tweet
  end
end
