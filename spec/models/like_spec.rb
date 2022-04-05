RSpec.describe Like do
  describe 'association' do
    specify { is_expected.to belong_to(:users)}
    specify { is_expected.to belong_to(:tweets_liked)}
  end
end