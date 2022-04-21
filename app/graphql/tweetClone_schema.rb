# frozen_string_literal: true

class TweetCloneSchema < GraphQL::Schema
  mutation Mutations::MutationType
  query Types::QueryType
end
