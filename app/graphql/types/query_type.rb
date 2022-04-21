module Types
  class QueryType < GraphQL::Schema::Object
    field :users, [Types::UserType]
    field :user, Types::UserType do
      argument :id, ID, required: true
    end

    def users
      User.all
    end

    def user(**args)
      User.find(args[:id])
    end

  end
end
