# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_16_132036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.integer "harvest_id"
    t.boolean "active"
    t.datetime "harvest_created_at"
    t.datetime "harvest_updated_at"
    t.string "statement_key"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["harvest_id"], name: "index_clients_on_harvest_id", unique: true
  end

  create_table "contracts", force: :cascade do |t|
    t.boolean "is_hourly"
    t.float "hourly_rate"
    t.float "salary"
    t.float "bonus"
    t.float "total_comp"
    t.date "start_date"
    t.date "end_date"
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_contracts_on_team_member_id"
  end

  create_table "daily_forecasts", force: :cascade do |t|
    t.jsonb "months"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "issue_date"
    t.integer "harvest_id"
    t.bigint "client_id", null: false
    t.float "amount"
    t.date "period_start"
    t.date "period_end"
    t.string "state"
    t.string "payment_term"
    t.date "sent_at"
    t.date "paid_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["harvest_id"], name: "index_invoices_on_harvest_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "harvest_id"
    t.integer "harvest_client_id"
    t.float "hourly_rate"
    t.boolean "hourly"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.float "revenue"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["harvest_id"], name: "index_projects_on_harvest_id", unique: true
  end

  create_table "team_members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "harvest_id"
    t.boolean "is_contractor"
    t.string "email"
    t.boolean "is_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "time_entries", force: :cascade do |t|
    t.date "spent_at"
    t.integer "harvest_id"
    t.text "notes"
    t.float "hours"
    t.integer "harvest_user_id"
    t.integer "harvest_project_id"
    t.integer "harvest_task_id"
    t.datetime "harvest_created_at"
    t.datetime "harvest_updated_at"
    t.boolean "is_billed"
    t.integer "harvest_invoice_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "project_id"
    t.boolean "billable"
    t.float "billable_rate"
    t.float "cost_rate"
    t.bigint "team_member_id"
    t.float "rounded_hours"
    t.integer "harvest_client_id"
    t.bigint "client_id"
    t.index ["harvest_id"], name: "index_time_entries_on_harvest_id", unique: true
    t.index ["project_id"], name: "index_time_entries_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "utilization_goals", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.integer "annualized_hours"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_utilization_goals_on_team_member_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contracts", "team_members"
  add_foreign_key "invoices", "clients"
  add_foreign_key "projects", "clients"
  add_foreign_key "time_entries", "projects"
  add_foreign_key "utilization_goals", "team_members"
end
