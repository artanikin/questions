require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author?' do
    let(:user) { create(:user) }

    context 'question' do
      it 'user is the author of the question' do
        question = create(:question, author: user)
        expect(user).to be_author(question)
      end

      it 'user is not the not author of the question' do
        question = create(:question)
        expect(user).to_not be_author(question)
      end
    end

    context 'answer' do
      it 'user is the author of the answer' do
        answer = create(:answer, author: user)
        expect(user).to be_author(answer)
      end

      it 'user is not the not author of the answer' do
        answer = create(:answer)
        expect(user).to_not be_author(answer)
      end
    end
  end
end
