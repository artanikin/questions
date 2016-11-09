require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :author }

  it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }
  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([-1,1]) }
  it do
    subject.author = create(:user)
    should validate_uniqueness_of(:author_id).scoped_to(:votable_type, :votable_id)
      .with_message('You have already voted')
  end
  it 'validates that voting user not author votable object' do
    user = create(:user)
    question = create(:question, author_id: user.id)
    vote = question.votes.build(author_id: user.id, value: 1)
    vote.valid?
    expect(vote.errors[:author_id]).to eq(["You can not vote for your question"])
  end
end
