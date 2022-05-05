# frozen_string_literal: true

RSpec.describe Tweet do
  describe 'association' do
    specify { is_expected.to belong_to(:user) }

    specify { is_expected.to have_many(:likes) }
    specify { is_expected.to have_many(:users) }

    it { is_expected.to validate_presence_of(:content) }
    it { should validate_presence_of(:content) }

    it 'is expected to validate presence of content' do
      expect(subject.valid?).to be_falsy
    end
  end

  describe 'scopes' do
    let(:user_1) do
      User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '', password: '123456',
                  password_confirmation: '123456')
    end
    let(:user_2) do
      User.create(name: 'Andrei', handle: 'andreihandle', email: 'andrei@email.com', bio: '', password: '123456',
                  password_confirmation: '123456')
    end
    let(:tweet_1) { Tweet.create(user_id: user_1.id, content: 'tweet1content') }
    let(:tweet_2) { Tweet.create(user_id: user_2.id, content: 'tweet2content') }
    let!(:like_1) { Like.create(user_id: user_1.id, tweet_id: tweet_1.id) }
    let!(:like_2) { Like.create(user_id: user_2.id, tweet_id: tweet_1.id) }

    context '.by_likes' do
      subject { Tweet.by_likes }
      specify { is_expected.to contain_exactly(tweet_1) }
    end

    context '.by_user_id' do
      subject { Tweet.by_user_id(user_id: user_2.id) }
      specify { is_expected.to contain_exactly(tweet_2) }
    end
  end
end
