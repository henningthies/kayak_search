# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100309092956) do

  create_table "airports", :force => true do |t|
    t.integer  "airportid"
    t.string   "iata_code"
    t.string   "icao_code"
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.float    "lat"
    t.float    "lng"
    t.integer  "incommings"
    t.integer  "outgoings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flights", :force => true do |t|
    t.string   "origin"
    t.string   "destination"
    t.date     "depart_date"
    t.integer  "arrival_airport_id"
    t.integer  "departure_airport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kayak_request_id"
  end

  create_table "kayak_requests", :force => true do |t|
    t.integer  "flight_id"
    t.text     "xml",          :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sid"
    t.string   "search_id"
    t.string   "more_pending"
  end

end
