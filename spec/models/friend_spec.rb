RSpec.describe Friend do
  describe 'association' do
    specify { is_expected.to belong_to(:followers)}
    specify { is_expected.to belong_to(:followings)}
  end
end