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

ActiveRecord::Schema.define(version: 2018_06_26_164706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", id: :serial, force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "ticket_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["ticket_id"], name: "index_cart_items_on_ticket_id"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sports", default: false, null: false
    t.string "slug"
    t.text "seodata"
    t.text "text"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "competitions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.text "text"
    t.string "avatar"
    t.string "slug"
    t.text "seodata"
    t.index ["category_id"], name: "index_competitions_on_category_id"
    t.index ["slug"], name: "index_competitions_on_slug", unique: true
  end

  create_table "enquiries", id: :serial, force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.string "name"
    t.string "email"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_enquiries_on_ticket_id"
  end

  create_table "event_info_blocks", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.string "title"
    t.text "text"
    t.integer "prior"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_info_blocks_on_event_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "venue_id"
    t.integer "category_id"
    t.integer "competition_id"
    t.boolean "sports", default: false, null: false
    t.boolean "priority", default: false, null: false
    t.string "slug"
    t.text "seodata"
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["competition_id"], name: "index_events_on_competition_id"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "events_players", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "player_id", null: false
    t.index ["event_id", "player_id"], name: "index_events_players_on_event_id_and_player_id"
    t.index ["player_id", "event_id"], name: "index_events_players_on_player_id_and_event_id"
  end

  create_table "home_line_items", id: :serial, force: :cascade do |t|
    t.integer "kind", default: 0, null: false
    t.integer "competition_id"
    t.integer "player_id"
    t.string "title"
    t.string "url"
    t.string "avatar"
    t.integer "prior", default: 9, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_home_line_items_on_competition_id"
    t.index ["player_id"], name: "index_home_line_items_on_player_id"
  end

  create_table "home_slides", id: :serial, force: :cascade do |t|
    t.integer "kind", default: 0, null: false
    t.string "huge_image"
    t.string "big_image"
    t.string "tile_image"
    t.boolean "manual_input"
    t.integer "event_id"
    t.string "title"
    t.string "url"
    t.string "avatar"
    t.string "place"
    t.date "start_date"
    t.date "end_date"
    t.integer "category_id"
    t.integer "prior", default: 9, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_home_slides_on_event_id"
    t.index ["kind"], name: "index_home_slides_on_kind"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id", null: false
    t.float "price"
    t.string "currency"
    t.integer "quantity"
    t.text "descr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "guid", null: false
    t.string "currency"
    t.float "shipping"
    t.string "txn_id"
    t.string "payer_paypal_id"
    t.string "address_name"
    t.string "address_country"
    t.string "address_country_code"
    t.string "address_zip"
    t.string "address_state"
    t.string "address_city"
    t.string "address_street"
    t.index ["guid"], name: "index_orders_on_guid"
    t.index ["txn_id"], name: "index_orders_on_txn_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "path", null: false
    t.text "body"
    t.text "seodata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_pages_on_path", unique: true
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.text "text"
    t.string "avatar"
    t.string "slug"
    t.text "seodata"
    t.index ["category_id"], name: "index_players_on_category_id"
    t.index ["slug"], name: "index_players_on_slug", unique: true
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.float "price"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "event_id"
    t.text "text"
    t.string "currency"
    t.boolean "pairs_only", default: false, null: false
    t.boolean "enquire"
    t.index ["event_id"], name: "index_tickets_on_event_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.boolean "agree_email"
    t.index ["agree_email"], name: "index_users_on_agree_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_categories_email_notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_users_categories_email_notifications_on_category_id"
    t.index ["user_id"], name: "index_users_categories_email_notifications_on_user_id"
  end

  create_table "venues", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "avatar"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "tickets"
  add_foreign_key "carts", "users"
  add_foreign_key "competitions", "categories"
  add_foreign_key "enquiries", "tickets"
  add_foreign_key "event_info_blocks", "events"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "competitions"
  add_foreign_key "events", "venues"
  add_foreign_key "home_line_items", "competitions"
  add_foreign_key "home_line_items", "players"
  add_foreign_key "home_slides", "categories"
  add_foreign_key "home_slides", "events"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "players", "categories"
  add_foreign_key "tickets", "events"
  add_foreign_key "users_categories_email_notifications", "categories"
  add_foreign_key "users_categories_email_notifications", "users"
end
