class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email
    mail subject: "Daily digest of new questions"
  end
end
