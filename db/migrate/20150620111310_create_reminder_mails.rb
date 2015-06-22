class CreateReminderMails < ActiveRecord::Migration
  def change
    create_table :reminder_mails, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :status
      t.timestamp :created_at, null: false
    end

    create_table :contacts_reminder_mails, id: false do |t|
      t.uuid :reminder_mail_id, null: false
      t.uuid :contact_id, null: false
    end
  end
end
