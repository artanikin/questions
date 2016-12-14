require "rails_helper"

RSpec.describe NotifySubscribersMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { NotifySubscribersMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Get new answer for question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@questions.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(question_url(question))
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
