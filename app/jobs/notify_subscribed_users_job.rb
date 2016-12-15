class NotifySubscribedUsersJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    subscribes = answer.question.subscribes

    unless subscribes.blank?
      subscribes.find_each do |subscribe|
        NotifySubscribersMailer.notify(subscribe.author, answer).deliver_now
      end
    end
  end
end
