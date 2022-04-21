module Mutations
  class MutationType < GraphQL::Schema::Object
    field :createUser, mutation: Mutations::CreateUser
  end
end