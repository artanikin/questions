require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let(:mail) { DailyMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest of new questions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["anikinartyom@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(questions.first.title)
      expect(mail.body.encoded).to match(questions.last.title)
      expect(mail.body.encoded).to match(question_url(questions.first))
      expect(mail.body.encoded).to match(question_url(questions.last))
    end
  end
end
