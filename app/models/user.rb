class User < ApplicationRecord
  has_many :tweets
  
  has_many :likes
  has_many :tweets_liked, through: :likes

  has_many :followers, dependent: :destroy, foreign_key: :following_id, class_name: "Friend"   
  has_many :follower, through: :followers, source: :followers

  has_many :followings, dependent: :destroy, foreign_key: :follower_id, class_name: "Friend"   
  has_many :following, through: :followings, source: :followings

  validates :name, presence: true
  validates :handle, :email, presence: true, length: { minimum: 5 }
end
