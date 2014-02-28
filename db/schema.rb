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

ActiveRecord::Schema.define(version: 20140228171206) do

  create_table "accounts", force: true do |t|
    t.float    "income"
    t.float    "expenditure"
    t.datetime "timestamp"
  end

  create_table "animals", force: true do |t|
    t.string  "name"
    t.string  "species"
    t.string  "breed"
    t.boolean "can_adopt"
    t.integer "charity_id"
  end

  add_index "animals", ["charity_id"], name: "index_animals_on_charity_id"

  create_table "charities", force: true do |t|
    t.string  "domain"
    t.string  "org_name"
    t.integer "user_id"
    t.integer "account_id"
    t.string  "email"
    t.integer "template"
    t.integer "charity_number"
    t.boolean "charity_number_verified"
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

  create_table "lost_cases", force: true do |t|
    t.string  "owner_email"
    t.string  "animal_name"
    t.integer "image_id"
    t.integer "video_id"
  end

  add_index "lost_cases", ["image_id"], name: "index_lost_cases_on_image_id"
  add_index "lost_cases", ["video_id"], name: "index_lost_cases_on_video_id"

  create_table "pages", force: true do |t|
    t.string  "title"
    t.integer "charity_id"
    t.integer "content_id"
    t.boolean "edit_disabled"
  end

  add_index "pages", ["charity_id"], name: "index_pages_on_charity_id"
  add_index "pages", ["content_id"], name: "index_pages_on_content_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "timestamp"
    t.integer  "charity_id"
    t.integer  "user_id"
  end

  add_index "posts", ["charity_id"], name: "index_posts_on_charity_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: true do |t|
    t.string "email"
    t.string "password_digest"
    t.string "password"
    t.string "password_confirmation"
    t.string "f_name"
    t.string "l_name"
  end

  create_table "videos", force: true do |t|
    t.string "data_src"
    t.string "title"
  end

end
