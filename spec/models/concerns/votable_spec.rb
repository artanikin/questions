require 'rails_helper'

shared_examples_for 'votable' do
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  it { should have_many(:votes) }

  describe "#with_rating" do
    let(:model) { create(described_class.to_s.underscore.to_sym) }

    it "has field rating" do
      create(:vote, votable: model, value: 1, author: first_user)
      expect(described_class.with_rating.first.has_attribute?(:rating)).to be(true)
    end
  end

  describe '#evaluation' do
    it 'positive' do
      create(:vote, votable: model, value: 1, author: first_user)
      create(:vote, votable: model, value: 1, author: second_user)

      expect(model.evaluation).to eq(2)
    end

    it 'negative' do
      create(:vote, votable: model, value: -1, author: first_user)
      create(:vote, votable: model, value: -1, author: second_user)

      expect(model.evaluation).to eq(-2)
    end

    it 'zero' do
      expect(model.evaluation).to be_zero
    end
  end
end
