# frozen_string_literal: true

class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :user
  has_many :likes
end
