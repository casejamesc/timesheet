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

ActiveRecord::Schema.define(version: 20140815215400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.boolean  "status"
    t.decimal  "rate"
    t.boolean  "default"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "shifts", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.text     "notes"
    t.decimal  "add_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "clock_in"
    t.time     "clock_out"
    t.date     "date_in"
    t.date     "date_out"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.boolean  "status"
    t.decimal  "rate"
    t.boolean  "default"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
  end

end
