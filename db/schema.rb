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

ActiveRecord::Schema.define(version: 2022_07_20_152809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "asana_projects", force: :cascade do |t|
    t.string "asana_id"
    t.string "name"
    t.boolean "archived"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.boolean "ignore"
    t.index ["asana_id"], name: "index_asana_projects_on_asana_id", unique: true
    t.index ["client_id"], name: "index_asana_projects_on_client_id"
  end

  create_table "asana_tasks", force: :cascade do |t|
    t.string "asana_id"
    t.string "name"
    t.date "completed_on"
    t.date "due_on"
    t.float "size"
    t.integer "unit_type"
    t.bigint "team_member_id"
    t.bigint "asana_project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "dev_days"
    t.bigint "client_id"
    t.index ["asana_id"], name: "index_asana_tasks_on_asana_id", unique: true
    t.index ["asana_project_id"], name: "index_asana_tasks_on_asana_project_id"
    t.index ["client_id"], name: "index_asana_tasks_on_client_id"
    t.index ["team_member_id"], name: "index_asana_tasks_on_team_member_id"
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

  create_table "contacts", force: :cascade do |t|
    t.integer "harvest_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "send_surveys"
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "recent_feedback_request_date"
    t.date "first_feedback_request_date"
    t.index ["client_id"], name: "index_contacts_on_client_id"
    t.index ["harvest_id"], name: "index_contacts_on_harvest_id", unique: true
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
    t.integer "target_billable_hours_per_year"
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

  create_table "feedback_requests", force: :cascade do |t|
    t.date "date"
    t.integer "rating"
    t.text "comment"
    t.boolean "communication"
    t.boolean "management"
    t.boolean "team"
    t.boolean "results"
    t.boolean "timeline"
    t.boolean "other"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.string "surveyable_type", null: false
    t.bigint "surveyable_id", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_feedback_requests_on_client_id"
    t.index ["surveyable_type", "surveyable_id"], name: "index_feedback_requests_on_surveyable"
    t.index ["token"], name: "index_feedback_requests_on_token", unique: true
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
    t.boolean "is_retainer"
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
    t.boolean "is_active"
    t.boolean "is_billable"
    t.string "asana_id"
    t.index ["asana_id"], name: "index_projects_on_asana_id", unique: true
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["harvest_id"], name: "index_projects_on_harvest_id", unique: true
  end

  create_table "task_assignments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "task_id", null: false
    t.boolean "is_active"
    t.integer "harvest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["harvest_id"], name: "index_task_assignments_on_harvest_id", unique: true
    t.index ["project_id"], name: "index_task_assignments_on_project_id"
    t.index ["task_id"], name: "index_task_assignments_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.boolean "is_active"
    t.integer "harvest_id"
    t.boolean "billable_by_default"
    t.string "name"
    t.boolean "is_default"
    t.datetime "harvest_created_at"
    t.datetime "harvest_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["harvest_id"], name: "index_tasks_on_harvest_id", unique: true
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
    t.date "start_date"
    t.date "end_date"
    t.float "billable_target_ratio"
    t.bigint "task_id"
    t.float "cost_per_hour"
    t.string "asana_id"
    t.date "recent_feedback_request_date"
    t.date "first_feedback_request_date"
    t.boolean "send_surveys"
    t.index ["asana_id"], name: "index_team_members_on_asana_id", unique: true
    t.index ["task_id"], name: "index_team_members_on_task_id"
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

  create_table "timesheet_allocations", force: :cascade do |t|
    t.bigint "timesheet_id", null: false
    t.float "allocation"
    t.bigint "project_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "task_id", null: false
    t.index ["project_id"], name: "index_timesheet_allocations_on_project_id"
    t.index ["task_id"], name: "index_timesheet_allocations_on_task_id"
    t.index ["timesheet_id"], name: "index_timesheet_allocations_on_timesheet_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.date "week"
    t.float "non_working_days"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_timesheets_on_team_member_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asana_projects", "clients"
  add_foreign_key "asana_tasks", "asana_projects"
  add_foreign_key "asana_tasks", "clients"
  add_foreign_key "asana_tasks", "team_members"
  add_foreign_key "contacts", "clients"
  add_foreign_key "contracts", "team_members"
  add_foreign_key "feedback_requests", "clients"
  add_foreign_key "invoices", "clients"
  add_foreign_key "projects", "clients"
  add_foreign_key "task_assignments", "projects"
  add_foreign_key "task_assignments", "tasks"
  add_foreign_key "team_members", "tasks"
  add_foreign_key "time_entries", "projects"
  add_foreign_key "timesheet_allocations", "projects"
  add_foreign_key "timesheet_allocations", "tasks"
  add_foreign_key "timesheet_allocations", "timesheets"
  add_foreign_key "timesheets", "team_members"
end
