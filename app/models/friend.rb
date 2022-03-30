class Friend < ApplicationRecord
  belongs_to :followers, foreign_key: "follower_id", class_name: "User"
  belongs_to :followings, foreign_key: "following_id", class_name: "User"
end
