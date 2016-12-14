class NotifySubscribedUsersJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribes = answer.question.subscribes

    unless subscribes.blank?
      subscribes.each do |subscribe|
        NotifySubscribersMailer.notify(subscribe.author, answer).deliver
      end
    end
  end
end
