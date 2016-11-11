shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  it { should have_many(:votes) }

  describe '#with_rating' do
    it 'has field rating' do
      create(:vote, votable: model, value: 1, author: user)
      expect(described_class.with_rating.first.has_attribute?(:rating)).to be(true)
    end
  end

  it '#evaluation' do
    create(:vote, votable: model, value: 1, author: user)
    create(:vote, votable: model, value: 1, author: create(:user))
    create(:vote, votable: model, value: 1, author: create(:user))
    create(:vote, votable: model, value: -1, author: create(:user))

    expect(model.evaluation).to eq(2)
  end
end
