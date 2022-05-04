# frozen_string_literal: true

RSpec.describe Types::UserType do
  subject { TweetCloneSchema.execute(query, variables: variables) }

  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      user(id: $id) {
        id
        name
        handle
      }
    }
  GRAPHQL
  let(:variables) { { id: user.id } }

  let(:user) { User.create(name: 'user', handle: 'userHandle', email: 'email@yahoo.com') }

  specify do
    expect(subject).to eq(
      {
        'data' => {
          'user' => {
            'id' => user.id.to_s,
            'name' => 'user',
            'handle' => 'userHandle'
          }
        }
      }
    )
  end
end
