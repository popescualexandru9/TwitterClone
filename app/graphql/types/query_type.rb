# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
    field :users, [Types::UserType]
    field :user, Types::UserType do
      argument :id, ID, required: true
    end

    field :tweets, [Types::TweetType]
    field :tweet, Types::TweetType do
      argument :id, ID, required: true
    end

    def users
      User.all
    end

    def tweets
      Tweet.all
    end

    def user(**args)
      User.find(args[:id])
    end

    def tweet(**args)
      Tweet.find(args[:id])
    end
  end
end
