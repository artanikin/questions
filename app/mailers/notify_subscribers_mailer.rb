class NotifySubscribersMailer < ApplicationMailer
  def notify(user, answer)
    @question = answer.question
    @answer = answer

    mail to: user.email
    mail subject: "Get new answer for question"
  end
end
