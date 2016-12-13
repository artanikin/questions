class DailyMailer < ApplicationMailer
  def digest(user)
    mail to: user.email
    mail subject: "Daily digest of new questions"
  end
end
