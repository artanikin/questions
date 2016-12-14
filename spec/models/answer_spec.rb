require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Authorable'
  it_behaves_like 'Attachable'

  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }


  describe '#mark_as_best' do
    let(:question) { create(:question) }

    it 'best answer not defined' do
      answer = create(:answer, question: question)
      answer.mark_as_best

      expect(answer.reload).to be_best
    end

    it 'best answer defined' do
      answer1 = create(:answer, question: question, best: true)
      answer2 = create(:answer, question: question)

      answer2.mark_as_best

      expect(answer1.reload).to_not be_best
      expect(answer2.reload).to be_best
    end
  end

  describe ".send_notification" do
    let(:question) { create(:question) }
    let!(:subscribes) { create_list(:subscribe, 2, question: question) }
    subject { build(:answer, question: question) }

    it "should send notification to all subscribe users after create answer" do
      question.subscribes do |subscribe|
        expect(NotifySubscribedUsersJob).to receive(:perform).with(subject).and_call_original
      end
      subject.save!
    end

    it "should not send notification after update answer" do
      subject.save!
      expect(subject).to_not receive(:notify_subscribed_users)
      subject.update(body: "This is updated body")
    end
  end
end
