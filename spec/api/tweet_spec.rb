# frozen_string_literal: true

RSpec.describe 'API Tweets', type: :request do
  let(:user) do
    User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '', password: '123456',
                password_confirmation: '123456')
  end

  describe '#index tweets' do
    context 'when user is authorized' do
      subject do
        get '/api/tweets#index', headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
        JSON.parse(response.body)
      end

      context 'when collection is empty' do
        it 'has a length of 0' do
          expect(subject).to eq([])
        end
      end

      context 'when collection is not empty' do
        it 'contains what it should be' do
          Tweet.create(user_id: user.id, content: 'tweetcontent')

          expect(subject.first).to include('content' => 'tweetcontent')
        end
      end
    end

    context 'when user is not authorized' do
      subject do
        get '/api/tweets#index'
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  describe '#show tweet' do
    let(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }

    context 'when user is authorize' do
      context 'when tweet is present' do
        it 'returns tweet' do
          get "/api/tweets/#{tweet.id}", headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }

          expect(response.body.length).not_to be_nil
          expect(JSON.parse(response.body)).to include({ 'content' => 'tweetcontent' })
        end
      end

      context 'when tweet is not present' do
        it 'return empty collection' do
          expect do
            get "/api/tweets/#{User.count + 1}",
                headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user is not authorized' do
      subject do
        get "/api/tweets/#{tweet.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  describe '#create tweet' do
    let(:params) { { tweet: { content: 'tweetcontent' } } }
    context 'when user is authorized' do
      context 'when tweet is created' do
        subject do
          post '/api/tweets', params: params,
                              headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          response
        end

        specify { expect(subject).to have_http_status(200) }
        specify { expect { JSON.parse(subject.body) }.to change(Tweet, :count).by(1) }
        specify { expect(JSON.parse(subject.body)).to include({ 'content' => 'tweetcontent' }) }
      end

      context 'when tweet is not created' do
        context 'when the content is non-existent' do
          subject do
            post '/api/tweets', params: { tweet: { user_id: user.id, content: '' } },
                                headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
            JSON.parse(response.body)
          end

          specify { expect(subject).to include('errors') }
        end
      end
    end

    context 'when user is not authorized' do
      subject do
        post '/api/tweets', params: params
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  describe '#update tweet ' do
    let!(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }
    context 'when user is authorized' do
      context 'when tweet is updated' do
        subject do
          patch "/api/tweets/#{tweet.id}", params: { tweet: { content: 'tweetcontentupdated' } },
                                           headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }

          response
        end

        specify { expect(subject).to have_http_status(200) }
        specify { expect(JSON.parse(subject.body)['content']).to eq('tweetcontentupdated') }
        specify { expect { subject }.to change { tweet.reload.content }.from('tweetcontent').to('tweetcontentupdated') }
      end

      context 'when tweet is not updated' do
        subject do
          patch "/api/tweets/#{user.id}", params: { tweet: { content: '' } },
                                          headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          JSON.parse(response.body)
        end

        specify { expect(subject).to include('errors') }
      end
    end

    context 'when user is not authorized' do
      subject do
        patch "/api/tweets/#{tweet.id}", params: { tweet: { content: 'some content' } }
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  describe '#destroy tweet' do
    let(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }
    context 'when user is authorized' do
      context 'when tweet is present' do
        specify do
          expect(delete("/api/tweets/#{tweet.id}",
                        headers: { "Authorization": JsonWebToken.encode(user_id: user.id) })).to eq(200)
        end
      end

      context 'when tweet is not present' do
        specify do
          expect do
            delete "/api/tweets/#{User.count + 1}",
                   headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user is not authorized' do
      subject do
        delete "/api/tweets/#{tweet.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  describe 'my method' do
    let!(:tweet) { Tweet.create(user_id: user.id, content: 'tweetcontent') }
    context 'when user is authorized' do
      subject do
        get '/api/tweets/my', headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
        JSON.parse(response.body)
      end

      context 'current user is not the same user passed here' do
        specify { expect(subject).to match([hash_including('id' => tweet.id)]) }
      end
    end

    context 'when user is not authorized' do
      subject do
        get '/api/tweets/my'
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end
end
