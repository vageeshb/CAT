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

ActiveRecord::Schema.define(version: 20140211111232) do

  create_table "exec_progresses", force: true do |t|
    t.integer  "user_id"
    t.integer  "test_id"
    t.integer  "test_step_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "queue_id"
  end

  create_table "executions", force: true do |t|
    t.integer  "user_id"
    t.integer  "test_suite_id"
    t.integer  "test_id"
    t.integer  "test_step_id"
    t.string   "status"
    t.datetime "last_run"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "login_test_data", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.boolean  "check"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_repositories", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.string  "url"
    t.text    "attachments"
    t.integer "user_id"
  end

  create_table "queue_carts", force: true do |t|
    t.integer  "test_suite_id"
    t.integer  "test_id"
    t.integer  "test_step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selenium_configs", force: true do |t|
    t.string   "browser"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_steps", force: true do |t|
    t.string   "step_name"
    t.text     "step_description"
    t.string   "expected"
    t.integer  "object_repository_id"
    t.string   "page_name"
    t.integer  "element_id"
    t.string   "function"
    t.string   "value"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "last_run"
  end

  create_table "test_suites", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "tests", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_suite_id"
    t.integer  "test_step_id"
    t.string   "status"
    t.datetime "last_run"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "password_digest"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "web_elements", force: true do |t|
    t.string   "page_name"
    t.string   "element_name"
    t.string   "element_type"
    t.string   "identifier_name"
    t.string   "identifier_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "object_repository_id"
  end

end
