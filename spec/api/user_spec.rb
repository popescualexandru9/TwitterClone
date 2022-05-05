# frozen_string_literal: true

RSpec.describe 'API Users', type: :request do
  context 'when user is not authorized' do
    context '#index' do
      subject do
        get '/api/users#index'
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#show' do
      let(:user) do
        User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '', password: '123456',
                    password_confirmation: '123456')
      end
      subject do
        get "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#update' do
      let(:user) do
        User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '', password: '123456',
                    password_confirmation: '123456')
      end
      subject do
        get "/api/users/#{user.id}", params: { user: { name: 'Alexandru' } }
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#destroy' do
      let(:user) do
        User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@email.com', bio: '', password: '123456',
                    password_confirmation: '123456')
      end
      subject do
        delete "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end

  context 'when user is authorized' do
    let!(:user) do
      User.create(name: 'Alex', handle: 'alexhandle', email: 'alex@gmail.com', password: '123456',
                  password_confirmation: '123456')
    end

    describe '#index users' do
      subject do
        get '/api/users', headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
        JSON.parse(response.body)
      end

      context 'when collection is not empty' do
        specify do
          expect(subject.first).to include('name' => 'Alex', 'handle' => 'alexhandle', 'email' => 'alex@gmail.com',
                                           'bio' => nil)
        end
      end
    end

    describe '#show user' do
      context 'when user is present' do
        it 'returns user' do
          get "/api/users/#{user.id}", headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          expect(response.body.length).not_to be_nil
          expect(JSON.parse(response.body)).to include({ 'name' => 'Alex', 'handle' => 'alexhandle',
                                                         'email' => 'alex@gmail.com', 'bio' => nil })
        end
      end

      context 'when user is not present' do
        it 'return empty collection' do
          # expect(response.status).to eq(404)
          expect do
            get "/api/users/#{User.count + 1}",
                headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe '#create user' do
      context 'when user is created' do
        let(:params) do
          { user: { name: 'Alex', handle: 'alexhandle', email: 'alex@gmail.com', bio: 'alexbio', password: '123456',
                    password_confirmation: '123456' } }
        end

        subject do
          post '/api/users', params: params
          response
        end

        specify { expect(subject).to have_http_status(200) }
        specify { expect { JSON.parse(subject.body) }.to change(User, :count).by(1) }
        specify do
          expect(JSON.parse(subject.body)).to include({ 'name' => 'Alex', 'handle' => 'alexhandle', 'email' => 'alex@gmail.com',
                                                        'bio' => 'alexbio' })
        end
      end

      context 'when user is not created' do
        context 'when the name is not present' do
          subject do
            post '/api/users', params: { user: { name: '', handle: 'alexhandle', email: 'alex@gmail.com', bio: '' } }
            JSON.parse(response.body)
          end

          specify { expect(subject).to include("Name can't be blank") }
        end

        context 'when the handle is not present' do
          subject do
            post '/api/users', params: { user: { name: 'Alex', handle: '', email: 'alex@gmail.com', bio: 'alexbio' } }
            JSON.parse(response.body)
          end
          specify { expect(subject).to include("Handle can't be blank") }
        end

        context 'when the email is not present' do
          subject do
            post '/api/users', params: { user: { name: 'Alex', handle: 'alexhandle', email: '', bio: '' } }
            JSON.parse(response.body)
          end
          specify { expect(subject).to include("Email can't be blank") }
        end

        context 'when the handle is too short' do
          subject do
            post '/api/users',
                 params: { user: { name: 'Alex', handle: 'hand', email: 'alex@gmail.com', bio: 'alexbio' } }
            JSON.parse(response.body)
          end
          specify { expect(subject).to include('Handle is too short (minimum is 5 characters)') }
        end

        context 'when the email is too short' do
          subject do
            post '/api/users', params: { user: { name: 'Alex', handle: 'alexhandle', email: 'alex', bio: '' } }
            JSON.parse(response.body)
          end
          specify { expect(subject).to include('Email is too short (minimum is 5 characters)') }
        end
      end
    end

    describe '#update user' do
      context 'when user is updated' do
        subject do
          patch "/api/users/#{user.id}", params: { user: { name: 'Alexandru' } },
                                         headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          response
        end

        specify { expect(subject).to have_http_status(200) }
        specify { expect(JSON.parse(subject.body)['name']).to eq('Alexandru') }
        specify { expect { subject }.to change { user.reload.name }.from('Alex').to('Alexandru') }
        # {} reloads the block
      end

      # Same cases as for #create
      # check for non-existent user
      context 'when user is not updated' do
        subject do
          patch "/api/users/#{user.id}", params: { user: { name: '' } },
                                         headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          JSON.parse(response.body)
        end

        specify { expect(subject).to include('errors') }
      end
    end

    describe '#destroy user' do
      context 'when user is present' do
        specify do
          expect(delete("/api/users/#{user.id}",
                        headers: { "Authorization": JsonWebToken.encode(user_id: user.id) })).to eq(200)
        end
      end

      context 'when user is not present' do
        specify do
          expect do
            delete "/api/users/#{User.count + 1}",
                   headers: { "Authorization": JsonWebToken.encode(user_id: user.id) }
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
