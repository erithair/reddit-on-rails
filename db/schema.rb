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

ActiveRecord::Schema.define(version: 20141115102441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["link_id"], name: "index_comments_on_link_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "links", force: true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["user_id"], name: "index_links_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.integer  "up"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["link_id", "user_id"], name: "index_votes_on_link_id_and_user_id", unique: true, using: :btree
  add_index "votes", ["link_id"], name: "index_votes_on_link_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

end
