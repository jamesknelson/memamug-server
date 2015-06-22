# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150620111310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "access_tokens", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",      null: false
    t.string   "access_token", null: false
    t.datetime "expires_at",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_tokens", ["access_token", "expires_at"], name: "index_access_tokens_on_access_token_and_expires_at", using: :btree
  add_index "access_tokens", ["access_token"], name: "index_access_tokens_on_access_token", unique: true, using: :btree
  add_index "access_tokens", ["expires_at"], name: "index_access_tokens_on_expires_at", using: :btree

  create_table "contacts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",       null: false
    t.string   "display_name",  null: false
    t.boolean  "starred"
    t.text     "notes"
    t.datetime "subscribed_on"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "contacts_reminder_mails", id: false, force: :cascade do |t|
    t.uuid "reminder_mail_id", null: false
    t.uuid "contact_id",       null: false
  end

  create_table "identities", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",               null: false
    t.string   "type",                  null: false
    t.string   "uid",                   null: false
    t.string   "api_token",             null: false
    t.datetime "expires_at"
    t.string   "avatar_url"
    t.datetime "avatar_url_fetched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["uid", "type"], name: "index_identities_on_uid_and_type", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "photos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "contact_id",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "reminder_mails", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.string   "status"
    t.datetime "created_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
