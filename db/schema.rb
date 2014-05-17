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

ActiveRecord::Schema.define(version: 20140517132823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credits", force: true do |t|
    t.string   "name"
    t.string   "last_name"
    t.integer  "phone"
    t.string   "personal_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "credit_sum"
    t.integer  "credit_period"
    t.date     "credit_start_date"
    t.integer  "credit_intress",    default: 25
  end

  create_table "payments", force: true do |t|
    t.date     "payment_date"
    t.float    "payment_balance"
    t.float    "princial_repayment"
    t.float    "intress_payment"
    t.float    "monthly_paymnet_total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credit_id"
  end

end
