# frozen_string_literal: true

RSpec.describe 'API Likes', type: :request do
  let(:user) { User.create(name: 'Alex', email: 'alex@gmail.com', handle: 'alexhandle') }
  let(:tweet) { Tweet.create(user_id: user.id, content: 'tweet_content') }

  describe '#index likes of tweet' do
    subject do
      get "/api/tweets/#{tweet.id}/likes"
      JSON.parse(response.body)
    end

    context 'when collection is empty' do
      it 'has a length of 0' do
        expect(subject).to eq([])
      end
    end

    context 'when collection is not empty' do
      it 'contains what it should be' do
        Like.create(user_id: user.id, tweet_id: tweet.id)
        expect(subject.first).to include('tweet' => JSON.parse(tweet.to_json), 'user' => JSON.parse(user.to_json))
      end
    end
  end

  describe '#show likes of a tweet' do
    context 'when like exists' do
      let(:like) { Like.create(user_id: user.id, tweet_id: tweet.id) }
      it 'returns like' do
        get "/api/tweets/#{tweet.id}/likes/#{user.handle}"
        expect(response.body.length).not_to be_nil
      end
    end

    context 'when like is non-existent' do
      it 'return empty collection' do
        expect { get "/api/tweets/#{tweet.id}/likes/'badhandle'" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create like a tweet' do
    context 'when like is created' do
      let(:params) { { like: { user_id: user.id } } }

      subject do
        post "/api/tweets/#{tweet.id}/likes", params: params
        response
      end

      specify { expect(subject).to have_http_status(200) }
      specify { expect { JSON.parse(subject.body) }.to change(Like, :count).by(1) }
      specify do
        expect(JSON.parse(subject.body)).to include('tweet' => JSON.parse(tweet.to_json),
                                                    'user' => JSON.parse(user.to_json))
      end
    end

    context 'when like is not created' do
      context 'when the user is non-existent' do
        subject do
          post "/api/tweets/#{tweet.id}/likes", params: { like: { user_id: User.count + 1 } }
          JSON.parse(response.body)
        end

        specify { expect(subject).to include('errors') }
      end
    end
  end

  describe '#destroy unlike a tweet' do
    context 'when like exists' do
      let(:like) { Like.create(user_id: user.id, tweet_id: tweet.id) }

      specify { expect(delete("/api/tweets/#{tweet.id}/likes/#{like.id}")).to eq(200) }
    end

    context 'when like is non-existent' do
      specify do
        expect do
          delete "/api/tweets/#{tweet.id}/likes/#{User.count + 1}"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
