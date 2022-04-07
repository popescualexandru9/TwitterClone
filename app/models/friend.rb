# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :follower_follows, foreign_key: 'follower_id', class_name: 'User'
  belongs_to :following_follows, foreign_key: 'following_id', class_name: 'User'
end
