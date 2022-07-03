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

ActiveRecord::Schema.define(version: 2022_06_30_134723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configurations", force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_configurations_on_key", unique: true
  end

  create_table "github_issues", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.string "status"
    t.string "assignees"
    t.string "label"
    t.datetime "milestone"
    t.boolean "track", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "project_column"
    t.string "project_name"
    t.boolean "verified", default: false
    t.integer "pr_opening", default: 0
    t.integer "pr_closed", default: 0
    t.string "created_by"
    t.string "pr_url"
    t.boolean "favourite", default: false
    t.string "due_date"
    t.index ["number"], name: "index_github_issues_on_number", unique: true
  end

  create_table "github_repositories", force: :cascade do |t|
    t.string "repo_id"
    t.string "name"
    t.string "url"
    t.integer "pr_opening", default: 0
    t.boolean "track", default: false
    t.boolean "verified", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
