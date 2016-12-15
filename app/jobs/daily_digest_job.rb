class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day.to_a

    unless questions.blank?
      User.find_each do |user|
        DailyMailer.digest(user, questions).deliver_later
      end
    end
  end
end
