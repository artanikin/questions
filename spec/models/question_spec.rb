require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }
  it { should have_many(:attachments) }
  it { should have_many(:votes) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  describe "#vote_up" do
    it "vote up to question" do
      question = create(:question)
      user = create(:user)
      expect{ question.vote_up(user) }.to change(question.votes, :count).by(1)
    end
  end
end
