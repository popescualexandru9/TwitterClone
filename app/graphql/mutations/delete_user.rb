# frozen_string_literal: true

module Mutations
  class DeleteUser < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    argument :id, ID, required: true

    def resolve(**args)
      user = User.find(args[:id])
      success = user.destroy
      {
        success:,
        errors: user.errors.full_messages
      }
    end
  end
end
