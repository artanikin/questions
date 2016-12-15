require "rails_helper"

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 2, author: users.first) }

  it "send daily digest" do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
