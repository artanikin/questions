class NotifySubscribersMailerPreview < ActionMailer::Preview

  def notify
    user = User.first
    answer = Answer.first
    NotifySubscribersMailer.notify(user, answer)
  end

end
