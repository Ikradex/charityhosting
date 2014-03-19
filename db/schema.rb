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

ActiveRecord::Schema.define(version: 20140319202404) do

  create_table "accounts", force: true do |t|
    t.float    "income"
    t.float    "expenditure"
    t.datetime "timestamp"
  end

  create_table "animals", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_sponsor"
    t.text     "description"
    t.integer  "image_id"
    t.integer  "charity_id"
    t.boolean  "can_adopt"
    t.string   "name"
    t.string   "species"
    t.string   "breed"
    t.string   "owner_email"
  end

  create_table "charities", force: true do |t|
    t.string   "domain"
    t.string   "org_name"
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "email"
    t.integer  "template"
    t.integer  "charity_number"
    t.boolean  "charity_number_verified"
    t.string   "org_address"
    t.string   "org_tel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charities", ["account_id"], name: "index_charities_on_account_id"
  add_index "charities", ["user_id"], name: "index_charities_on_user_id"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.datetime "timestamp"
    t.integer  "guest_id"
    t.integer  "user_id"
  end

  add_index "comments", ["guest_id"], name: "index_comments_on_guest_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "contents", force: true do |t|
    t.text    "content_src"
    t.integer "page_id"
  end

  add_index "contents", ["page_id"], name: "index_contents_on_page_id"

  create_table "donations", force: true do |t|
    t.float    "amount"
    t.datetime "timestamp"
    t.string   "token"
    t.string   "email"
    t.integer  "charity_id"
  end

  create_table "guests", force: true do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "password"
    t.string "password_confirmation"
  end

  create_table "images", force: true do |t|
    t.string "data_src"
    t.string "alt_desc"
    t.string "mime_type"
  end

  create_table "pages", force: true do |t|
    t.string  "title"
    t.integer "charity_id"
    t.integer "content_id"
    t.boolean "edit_disabled"
    t.boolean "editable"
  end

  add_index "pages", ["charity_id"], name: "index_pages_on_charity_id"
  add_index "pages", ["content_id"], name: "index_pages_on_content_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "timestamp"
    t.integer  "charity_id"
    t.integer  "user_id"
    t.text     "post_content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
  end

  add_index "posts", ["charity_id"], name: "index_posts_on_charity_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "requests", force: true do |t|
    t.string   "domain"
    t.string   "org_name"
    t.string   "email"
    t.integer  "template"
    t.integer  "charity_number"
    t.boolean  "charity_number_verified"
    t.string   "org_address"
    t.string   "org_tel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
    t.string   "approval_token"
  end

  create_table "table_lost_cases", force: true do |t|
    t.string  "owner_email"
    t.string  "animal_name"
    t.string  "description"
    t.integer "image_id"
  end

  create_table "users", force: true do |t|
    t.string  "email"
    t.string  "password_digest"
    t.string  "password"
    t.string  "password_confirmation"
    t.string  "f_name"
    t.string  "l_name"
    t.boolean "is_admin"
  end

  create_table "videos", force: true do |t|
    t.string "data_src"
    t.string "title"
  end

end
