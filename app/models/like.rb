class Like < ApplicationRecord
  belongs_to :users, class_name: 'User', foreign_key: 'user_id'
  belongs_to :tweets_liked, class_name: 'Tweet', foreign_key: 'tweet_id'
end
