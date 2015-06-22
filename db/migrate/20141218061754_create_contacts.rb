class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts, id: :uuid do |t|
      t.uuid :user_id, null: false

      t.string :display_name, null: false
      t.boolean :starred
      t.text :notes

      t.timestamp :subscribed_on

      t.timestamps null: false
    end
  end
end
