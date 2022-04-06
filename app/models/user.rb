class User < ApplicationRecord
  alias_attribute :tweets_liked, :likes
  
  has_many :tweets
  
  has_many :likes
  has_many :tweets_liked, through: :likes

  has_many :follower_follows, dependent: :destroy, foreign_key: :following_id, class_name: "Friend" 
  has_many :followers, through: :follower_follows, source: :follower_follows

  has_many :following_follows, dependent: :destroy, foreign_key: :follower_id, class_name: "Friend" 
  has_many :followings, through: :following_follows, source: :following_follows

  validates :name, presence: true
  validates :handle, :email, presence: true, length: { minimum: 5 }
end
