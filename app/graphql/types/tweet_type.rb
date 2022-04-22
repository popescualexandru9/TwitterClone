# frozen_string_literal: true

module Types
  class TweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :content, String, null: false
    field :user, Types::UserType, null: false
  end
end
