# frozen_string_literal: true

module Inputs
  class UserInput < GraphQL::Schema::InputObject
    argument :name, String, required: true
    argument :handle, String, required: true
    argument :email, String, required: true
    argument :bio, String, required: false
  end
end
