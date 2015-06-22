class ReminderMail < Thor
  require File.expand_path("../../../config/environment.rb", __FILE__)

  desc 'send', "Send a reminder mail to anybody who is expecting one today, and hasn't yet received it today"
  def send
    today = Time.zone.today
    User.all.each do |user|
      contacts = user.reminder_contacts_for(today, today)
      
      reminder_mail = user.reminder_mails.build(status: 'new')
      reminder_mail.contacts << contacts
      reminder_mail.save!
        
      begin
        ReminderMailer.daily_email(reminder_mail).deliver_now
        reminder_mail.update_attribute('status', 'sent')
      rescue => error
        reminder_mail.update_attribute('status', 'error')
      end
    end
  end
end
