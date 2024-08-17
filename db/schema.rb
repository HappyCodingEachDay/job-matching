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

ActiveRecord::Schema[7.1].define(version: 2024_08_17_115501) do
  create_table "job_seekers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.json "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.json "required_skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "job_seeker_id", null: false
    t.integer "matching_skill_count", default: 0
    t.integer "matching_skill_percent", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "job_seeker_id"], name: "index_recommendations_on_job_id_and_job_seeker_id", unique: true
    t.index ["job_id"], name: "index_recommendations_on_job_id"
    t.index ["job_seeker_id"], name: "index_recommendations_on_job_seeker_id"
  end

  add_foreign_key "recommendations", "job_seekers"
  add_foreign_key "recommendations", "jobs"
end
