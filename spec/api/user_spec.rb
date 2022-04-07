 RSpec.describe 'API Users', type: :request do

  describe '#index' do
    before do
      get '/api/users#index'
    end

    context 'when collection is empty' do
      it 'has a length of 0' do
        expect(JSON.parse(response.body)).to eq([]) 
      end
    end

    context 'when collection is not empty' do
      it 'has a length bigger than 0' do
        expect(response.body.length).to (be>0) 
      end
    end
  end

  describe '#show' do
    context 'when user is present' do
      let(:user) { User.create(name: "Alex", handle: "alexhandle", email: "alex@email.com")}
      
      it 'returns user' do
        get "/api/users/#{user.id}"
        expect(response.body.length).not_to be_nil 
      end
    end

    context 'when user is not present' do
      it 'return empty collection' do
        expect{get "/api/users/#{rand(1000)}"}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create' do
    context 'when user is created' do
      let(:params) { {user: {name: "Alex", handle: "alexhandle", email: "alex@gmail.com", bio: "alexbio"}}} 
      
      subject do
        post "/api/users", params: params
        response
      end

      specify { expect(subject).to have_http_status(200) }
      specify { expect {JSON.parse(subject.body)}.to change(User, :count).by(1) }
    end

    context 'when user is not created' do
      context 'when the name is not present' do
        subject do
          post "/api/users", params: {user: {name: "", handle: "alexhandle", email: "alex@gmail.com", bio: ""}}
          JSON.parse(response.body)
        end

        specify { expect(subject).to include("Name can't be blank") }
      end

      context 'when the handle is not present' do
        subject do
          post "/api/users", params: {user: {name: "Alex", handle: "", email: "alex@gmail.com", bio: "alexbio"}}
          JSON.parse(response.body)
        end
        specify { expect(subject).to include("Handle can't be blank") }
      end

      context 'when the email is not present' do
        subject do
          post "/api/users", params: {user: {name: "Alex", handle: "alexhandle", email: "", bio: ""}}
          JSON.parse(response.body)
        end
         specify { expect(subject).to include("Email can't be blank") }
      end

      context 'when the handle is too short' do
        subject do
          post "/api/users", params: {user: {name: "Alex", handle: "hand", email: "alex@gmail.com", bio: "alexbio"}}
          JSON.parse(response.body)
        end
        specify { expect(subject).to include("Handle is too short (minimum is 5 characters)") }
      end

      context 'when the email is too short' do
        subject do
          post "/api/users", params: {user: {name: "Alex", handle: "alexhandle", email: "alex", bio: ""}}
          JSON.parse(response.body)
        end
        specify { expect(subject).to include("Email is too short (minimum is 5 characters)") }
      end
    end
  end

  describe '#update' do
    let(:user) { User.create(name: "Alex", handle: "alexhandle", email: "alex@email.com", bio: "")}
    
    context 'when user is updated' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {name: 'Alexandru'}}
        response
      end

      specify { expect(subject).to have_http_status(200) }
      specify { expect(JSON.parse(subject.body)['name']).to eq('Alexandru') }
    end

    # Same cases as for #create
    context 'when user is not updated' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {name: ""}}
        JSON.parse(response.body)
      end

      specify { expect(subject).to include('errors') }
    end
  end

  describe '#destroy' do
    context 'when user is present' do
      let(:user) { User.create(name: "Alex", handle: "alexhandle", email: "alex@email.com")}

      specify { expect(delete "/api/users/#{user.id}").to eq(200) }
    end

    context 'when user is not present' do
      specify { expect {delete "/api/users/#{rand(1000)}"}.to raise_error(ActiveRecord::RecordNotFound)}
    end
  end


end
