class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :users, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false

      t.timestamps null: false

      t.index :email, unique: true
    end

    create_table :access_tokens, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :access_token, null: false
      t.datetime :expires_at, null: false
      t.timestamps null: false

      t.index :access_token, unique: true
      t.index [:access_token, :expires_at]
      t.index :expires_at
    end

    create_table :identities, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :type, null: false
      t.string :uid, null: false

      t.string :api_token, null: false
      t.datetime :expires_at

      t.string :avatar_url
      t.timestamp :avatar_url_fetched_at

      t.timestamps null: false

      t.index :user_id
      t.index [:uid, :type], unique: true
    end
  end
end
