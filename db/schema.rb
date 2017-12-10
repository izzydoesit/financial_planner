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

ActiveRecord::Schema.define(version: 20171209211227) do

  create_table "income_years", force: :cascade do |t|
    t.string   "year"
    t.float    "income"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_income_years_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "age"
    t.string   "sex"
    t.date     "birthday"
    t.float    "full_retirement_age"
    t.float    "current_income"
    t.integer  "life_expectancy"
    t.date     "claim_date"
    t.boolean  "spousal_benefits",    default: false
    t.float    "monthly_amie_base"
    t.float    "maximum_benefit"
    t.float    "adjusted_benefit"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
