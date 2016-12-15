class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day

    unless questions.blank?
      User.find_each do |user|
        DailyMailer.digest(user, questions).deliver_now
      end
    end
  end
end
