# frozen_string_literal: true

module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: false
    field :handle, String, null: false
    field :bio, String, null: true
    field :email, String, null: false
  end
end
