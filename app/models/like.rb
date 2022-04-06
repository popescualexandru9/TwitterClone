class Like < ApplicationRecord
  belongs_to :user # class_name: 'User', foreign_key: 'user_id' -- pluralize
  belongs_to :tweet
end
