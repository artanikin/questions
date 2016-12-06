shared_examples_for 'Votable' do
  let(:user) { create(:user) }
  let(:john) { create(:user) }
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

  describe '#vote_up' do
    let(:question) { create(:question, author: john) }

    it 'add new vote up' do
      expect(question.vote_up(user)).to match_array([nil, "You voted for question"])
      expect(question.evaluation).to eq(1)
    end

    it 'remove vote up' do
      question.vote_up(user)

      expect(question.vote_up(user)).to match_array([nil, "You unvoted for question"])
      expect(question.evaluation).to eq(0)
    end

    it 'can not vote up for his question' do
      expect(question.vote_up(john)).to match_array([true, [["You can not vote for your question"]]])
      expect(question.evaluation).to eq(0)
    end
  end

  describe '#vote_down' do
    let(:question) { create(:question, author: john) }

    it 'add new vote down' do
      expect(question.vote_down(user)).to match_array([nil, "You voted for question"])
      expect(question.evaluation).to eq(-1)
    end

    it 'remove vote down' do
      question.vote_down(user)

      expect(question.vote_down(user)).to match_array([nil, "You unvoted for question"])
      expect(question.evaluation).to eq(0)
    end

    it 'can not vote down for his question' do
      expect(question.vote_down(john)).to match_array([true, [["You can not vote for your question"]]])
      expect(question.evaluation).to eq(0)
    end
  end
end
