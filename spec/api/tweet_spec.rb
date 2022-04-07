# frozen_string_literal: true

RSpec.describe 'API Tweets', type: :request do
  let(:user) { User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '') }

  describe '#index tweets' do
    subject do
      get '/api/tweets#index'
      JSON.parse(response.body)
    end

    context 'when collection is empty' do
      it 'has a length of 0' do
        expect(subject).to eq([])
      end
    end

    context 'when collection is not empty' do
      it 'has a length of' do
        Tweet.create(user_id: user.id, content: 'tweetcontent')
        expect(subject.length).to eq(1)
      end
    end
  end

  describe '#show tweet' do
    context 'when tweet is present' do
      let(:tweet) { Tweet.create(user_id: 1, content: 'tweetcontent') }

      it 'returns tweet' do
        get "/api/tweets/#{tweet.id}"
        expect(response.body.length).not_to be_nil
      end
    end

    context 'when tweet is not present' do
      it 'return empty collection' do
        expect { get "/api/tweets/#{rand(1000)}" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create tweet' do
    context 'when tweet is created' do
      let(:params) { { tweet: { user_id: user.id, content: 'tweetcontent' } } }

      subject do
        post '/api/tweets', params: params
        response
      end

      specify { expect(subject).to have_http_status(200) }
      specify { expect { JSON.parse(subject.body) }.to change(Tweet, :count).by(1) }
    end

    context 'when tweet is not created' do
      context 'when the user is non-existent' do
        subject do
          post '/api/tweets', params: { tweet: { user_id: rand(1000), content: 'tweetcontent' } }
          JSON.parse(response.body)
        end

        specify { expect(subject).to include('errors') }
      end
    end
  end

  describe '#update tweet ' do
    let!(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }

    context 'when tweet is updated' do
      subject do
        patch "/api/tweets/#{tweet.id}", params: { tweet: { content: 'tweetcontentupdated' } }
        response
      end

      specify { expect(subject).to have_http_status(200) }
      specify { expect(JSON.parse(subject.body)['content']).to eq('tweetcontentupdated') }
    end

    context 'when tweet is not updated' do
      subject do
        patch "/api/tweets/#{user.id}", params: { tweet: { content: '' } }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include('errors') }
    end
  end

  describe '#destroy weet' do
    context 'when tweet is present' do
      let(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }

      specify { expect(delete("/api/tweets/#{tweet.id}")).to eq(200) }
    end

    context 'when tweet is not present' do
      specify { expect { delete "/api/tweets/#{rand(1000)}" }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
