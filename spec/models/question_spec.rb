require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Authorable'
  it_behaves_like 'Attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  describe "subscribe" do
    let(:user) { create(:user) }
    subject { build(:question, author: user) }

    it "should subscribe after create" do
      expect(subject).to receive(:subscribe_author)
      subject.save!
    end

    it "should not subscribe after update question" do
      subject.save!
      expect(subject).to_not receive(:subscribe_author)
      subject.update(body: "This is updated body")
    end
  end
end
