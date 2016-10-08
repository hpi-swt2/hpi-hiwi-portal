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

ActiveRecord::Schema.define(version: 20160912132740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alumnis", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email",                     null: false
    t.string   "alumni_email",              null: false
    t.string   "token",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hidden_title"
    t.string   "hidden_birth_name"
    t.integer  "hidden_graduation_id"
    t.integer  "hidden_graduation_year"
    t.string   "hidden_private_email"
    t.string   "hidden_alumni_email"
    t.string   "hidden_additional_email"
    t.string   "hidden_last_employer"
    t.string   "hidden_current_position"
    t.string   "hidden_street"
    t.string   "hidden_location"
    t.string   "hidden_postcode"
    t.string   "hidden_country"
    t.string   "hidden_phone_number"
    t.string   "hidden_comment"
    t.string   "hidden_agreed_alumni_work"
  end

  create_table "assignments", force: true do |t|
    t.integer  "student_id"
    t.integer  "job_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurables", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurables", ["name"], name: "index_configurables_on_name", using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "counterpart_id"
    t.string   "counterpart_type"
    t.string   "name"
    t.string   "street"
    t.string   "zip_city"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_educations", force: true do |t|
    t.integer  "student_id"
    t.string   "degree"
    t.string   "field"
    t.string   "institution"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_jobs", force: true do |t|
    t.integer  "student_id"
    t.string   "position"
    t.string   "employer"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",     default: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "activated",             default: false, null: false
    t.string   "place_of_business"
    t.string   "website"
    t.string   "line_of_business"
    t.integer  "year_of_foundation"
    t.string   "number_of_employees"
    t.integer  "requested_package_id",  default: 0,     null: false
    t.integer  "booked_package_id",     default: 0,     null: false
    t.integer  "single_jobs_requested", default: 0,     null: false
    t.string   "token"
  end

  add_index "employers", ["name"], name: "index_employers_on_name", unique: true, using: :btree

  create_table "employers_job_offers", id: false, force: true do |t|
    t.integer "employer_id"
    t.integer "job_offer_id"
  end

  add_index "employers_job_offers", ["employer_id", "job_offer_id"], name: "index_employers_job_offers_on_employer_id_and_job_offer_id", unique: true, using: :btree

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
  end

  create_table "job_offers", force: true do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "time_effort"
    t.float    "compensation"
    t.integer  "employer_id"
    t.integer  "status_id"
    t.boolean  "flexible_start_date",       default: false
    t.integer  "category_id",               default: 0,     null: false
    t.integer  "state_id",                  default: 3,     null: false
    t.integer  "graduation_id",             default: 2,     null: false
    t.boolean  "prolong_requested",         default: false
    t.boolean  "prolonged",                 default: false
    t.datetime "prolonged_at"
    t.date     "release_date"
    t.string   "offer_as_pdf_file_name"
    t.string   "offer_as_pdf_content_type"
    t.integer  "offer_as_pdf_file_size"
    t.datetime "offer_as_pdf_updated_at"
    t.integer  "student_group_id",          default: 0,     null: false
  end

  create_table "job_offers_languages", id: false, force: true do |t|
    t.integer "job_offer_id"
    t.integer "language_id"
  end

  add_index "job_offers_languages", ["job_offer_id", "language_id"], name: "jo_l_index", unique: true, using: :btree

  create_table "job_offers_programming_languages", id: false, force: true do |t|
    t.integer "job_offer_id"
    t.integer "programming_language_id"
  end

  add_index "job_offers_programming_languages", ["job_offer_id", "programming_language_id"], name: "jo_pl_index", unique: true, using: :btree

  create_table "job_offers_students", id: false, force: true do |t|
    t.integer "job_offer_id"
    t.integer "student_id"
  end

  add_index "job_offers_students", ["job_offer_id", "student_id"], name: "jo_s_index", unique: true, using: :btree

  create_table "job_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_users", force: true do |t|
    t.integer "student_id"
    t.integer "language_id"
    t.integer "skill"
  end

  create_table "newsletter_orders", force: true do |t|
    t.integer  "student_id"
    t.text     "search_params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programming_languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programming_languages_users", force: true do |t|
    t.integer "student_id"
    t.integer "programming_language_id"
    t.integer "skill"
  end

  create_table "ratings", force: true do |t|
    t.integer "student_id"
    t.integer "employer_id"
    t.integer "job_offer_id"
    t.string  "headline"
    t.text    "description"
    t.integer "score_overall"
    t.integer "score_atmosphere"
    t.integer "score_salary"
    t.integer "score_work_life_balance"
    t.integer "score_work_contents"
  end

  add_index "ratings", ["employer_id"], name: "index_ratings_on_employer_id", using: :btree
  add_index "ratings", ["job_offer_id"], name: "index_ratings_on_job_offer_id", using: :btree
  add_index "ratings", ["student_id"], name: "index_ratings_on_student_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "staffs", force: true do |t|
    t.integer  "employer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.integer  "semester"
    t.string   "academic_program"
    t.text     "education"
    t.text     "additional_information"
    t.date     "birthday"
    t.string   "homepage"
    t.string   "github"
    t.string   "facebook"
    t.string   "xing"
    t.string   "linkedin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_status_id",      default: 0, null: false
    t.integer  "frequency",                 default: 1, null: false
    t.integer  "academic_program_id",       default: 0, null: false
    t.integer  "graduation_id",             default: 0, null: false
    t.integer  "visibility_id",             default: 0, null: false
    t.integer  "dschool_status_id",         default: 0, null: false
    t.integer  "group_id",                  default: 0, null: false
    t.string   "hidden_title"
    t.string   "hidden_birth_name"
    t.integer  "hidden_graduation_id"
    t.integer  "hidden_graduation_year"
    t.string   "hidden_private_email"
    t.string   "hidden_alumni_email"
    t.string   "hidden_additional_email"
    t.string   "hidden_last_employer"
    t.string   "hidden_current_position"
    t.string   "hidden_street"
    t.string   "hidden_location"
    t.string   "hidden_postcode"
    t.string   "hidden_country"
    t.string   "hidden_phone_number"
    t.string   "hidden_comment"
    t.string   "hidden_agreed_alumni_work"
  end

  create_table "users", force: true do |t|
    t.string   "email",              default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "cv_file_name"
    t.string   "cv_content_type"
    t.integer  "cv_file_size"
    t.datetime "cv_updated_at"
    t.integer  "status"
    t.integer  "manifestation_id"
    t.string   "manifestation_type"
    t.string   "password_digest"
    t.boolean  "activated",          default: false, null: false
    t.boolean  "admin",              default: false, null: false
    t.string   "alumni_email",       default: "",    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
