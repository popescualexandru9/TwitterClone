# frozen_string_literal: true

class Tweet < ApplicationRecord
  attr_readonly :likes_count
  belongs_to :user

  has_many :likes
  has_many :users, through: :likes

  validates :content, presence: true

  scope :by_user_id, ->(user_id: 1) { where(user_id: user_id)}
  scope :by_likes, ->(like_count: 1) { joins(:likes).group("likes.tweet_id").having("count(likes.id) > ?", like_count) }
  #scope :have_min_likes, ->(nr_likes:2) {where(id: Like.select(:tweet_id).group(:tweet_id).having('count(*) > ?', nr_likes))}

  scope :order_by_created_at, -> { order(created_at: )}
  scope :order_by_updated_at, -> { order(updated_at: )}
  scope :order_by_no_likes, -> { joins(:likes).group(:id).order("COUNT(likes.id) DESC")} 
  scope :order_by_users_at, -> { joins(:user).order('users.name DESC')}
end
