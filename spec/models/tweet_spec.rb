RSpec.describe Tweet do
  describe 'association' do
    specify { is_expected.to belong_to(:user)}
    
    specify { is_expected.to have_many(:likes)}
    specify { is_expected.to have_many(:users)}

    it { is_expected.to validate_presence_of(:content)}
    it { should validate_presence_of(:content)}

    it 'is expected to validate presence of content' do
      expect(subject.valid?).to be_falsy
    end
  end
end