# frozen_string_literal: true

module Mutations
  class CreateUser < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::UserType, null: true

    argument :user_input, Inputs::UserInput, required: true

    def resolve(**args)
      user = User.new(args[:user_input].to_h)
      success = user.save
      {
        success:,
        errors: user.errors.full_messages,
        user: success ? user : nil
      }
    end
  end
end
