# frozen_string_literal: true

module Mutations
  class MutationType < GraphQL::Schema::Object
    field :createUser, mutation: Mutations::CreateUser
    field :deleteUser, mutation: Mutations::DeleteUser
    field :updateUser, mutation: Mutations::UpdateUser
  end
end
