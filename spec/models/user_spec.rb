RSpec.describe User do
  describe 'association' do
    specify { is_expected.to have_many(:tweets)}

    specify { is_expected.to have_many(:likes)}
    specify { is_expected.to have_many(:tweets_liked)}

    specify { is_expected.to have_many(:followers)}
    specify { is_expected.to have_many(:followings)}
  end

  describe 'presence' do
    specify {is_expected.to validate_presence_of(:name)}
    specify {is_expected.to validate_presence_of(:handle)}
    specify {is_expected.to validate_presence_of(:email)}
  end

  describe 'length' do
    specify {should validate_length_of(:handle).is_at_least(5)}
    specify {should validate_length_of(:email).is_at_least(5)}
  end
end
