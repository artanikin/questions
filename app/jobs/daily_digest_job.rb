class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    User.send_daily_digest
  end
end
