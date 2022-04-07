# frozen_string_literal: true

RSpec.describe Friend do
  describe 'association' do
    specify { is_expected.to belong_to(:follower_follows) }
    specify { is_expected.to belong_to(:following_follows) }
  end
end
