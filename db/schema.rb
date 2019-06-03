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

ActiveRecord::Schema.define(version: 20190603120953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "harvest_id"
    t.boolean  "active"
    t.datetime "harvest_created_at"
    t.datetime "harvest_updated_at"
    t.string   "statement_key"
    t.text     "details"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "harvest_id"
    t.integer  "harvest_client_id"
    t.float    "hourly_rate"
    t.boolean  "hourly"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "client_id"
    t.float    "revenue"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "time_entries", force: :cascade do |t|
    t.date     "spent_at"
    t.integer  "harvest_id"
    t.text     "notes"
    t.float    "hours"
    t.integer  "harvest_user_id"
    t.integer  "harvest_project_id"
    t.integer  "harvest_task_id"
    t.datetime "harvest_created_at"
    t.datetime "harvest_updated_at"
    t.boolean  "is_billed"
    t.integer  "harvest_invoice_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "project_id"
    t.boolean  "billable"
    t.float    "billable_rate"
    t.float    "cost_rate"
  end

  add_index "time_entries", ["project_id"], name: "index_time_entries_on_project_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "projects", "clients"
  add_foreign_key "time_entries", "projects"
end
