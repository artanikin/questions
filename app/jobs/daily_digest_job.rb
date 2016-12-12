class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.send_daily_digest
  end
end
