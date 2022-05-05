# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  alias_attribute :tweets_liked, :likes

  has_many :tweets

  has_many :likes
  has_many :tweets_liked, through: :likes

  has_many :follower_follows, dependent: :destroy, foreign_key: :following_id, class_name: 'Friend'
  has_many :followers, through: :follower_follows, source: :follower_follows

  has_many :following_follows, dependent: :destroy, foreign_key: :follower_id, class_name: 'Friend'
  has_many :followings, through: :following_follows, source: :following_follows

  validates :name, presence: true
  validates :handle, :email, presence: true, length: { minimum: 5 }

  scope :tweet_likes, ->(tweet_id: 1) { joins(:likes).group('likes.user_id').where(tweet_id:) }
  scope :by_handle, ->(handle: 'a%') { where('handle like ?', handle) }

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
