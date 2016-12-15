require 'rails_helper'

RSpec.describe NotifySubscribedUsersJob, type: :job do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:subscribes) { create_list(:subscribe, 2, question: question) }
  let(:answer) { create(:answer, question: question, author: author) }

  it "send notify to subscribed users" do
    question.subscribes.each do |subscribe|
      expect(NotifySubscribersMailer).to receive(:notify).with(subscribe.author, answer).and_call_original
    end
    NotifySubscribedUsersJob.perform_now(answer)
  end
end
