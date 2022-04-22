# frozen_string_literal: true

module Mutations
  class UpdateUser < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::UserType, null: true

    argument :id, ID, required: true
    argument :new_name, String, required: true
    argument :new_email, String, required: true

    def resolve(**args)
      user = User.find(args[:id])
      user.name = args[:new_name]
      user.email = args[:new_email]

      success = user.save
      {
        success:,
        errors: user.errors.full_messages,
        user: success ? user : nil
      }
    end
  end
end
