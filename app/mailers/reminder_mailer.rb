class ReminderMailer < ApplicationMailer
  default from: "reminders@memamug.com"

  def daily_email(reminder_mail)
    @reminder_mail = reminder_mail
    mail(to: reminder_mail.user.email, subject: 'Remember these people?')
  end
end
