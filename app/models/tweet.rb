# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user

  has_many :likes
  has_many :users, through: :likes

  validates :content, presence: true
end
