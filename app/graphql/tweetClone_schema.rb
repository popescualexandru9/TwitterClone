# frozen_string_literal: true

class TweetCloneSchema < GraphQL::Schema
  query Types::QueryType
  mutation Mutations::MutationType
end
