require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'authorable'
  it_behaves_like 'attachable'

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
end
