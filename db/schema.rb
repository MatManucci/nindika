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

ActiveRecord::Schema.define(version: 2021_08_15_001231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "event_dispatches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_event_id", null: false
    t.string "provider", null: false
    t.string "sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_event_id", "provider", "sent_at"], name: "idx_event_provider_sent_at", where: "(sent_at IS NULL)"
    t.index ["item_event_id", "provider"], name: "index_event_dispatches_on_item_event_id_and_provider", unique: true
    t.index ["item_event_id"], name: "index_event_dispatches_on_item_event_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.uuid "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "hidden_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_hidden_items_on_item_id"
    t.index ["user_id", "item_id"], name: "index_hidden_items_on_user_id_and_item_id", unique: true
    t.index ["user_id"], name: "index_hidden_items_on_user_id"
  end

  create_table "item_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id", null: false
    t.string "event_type", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at", "event_type"], name: "index_item_events_on_created_at_and_event_type", order: { created_at: :desc }
    t.index ["item_id"], name: "index_item_events_on_item_id"
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", limit: 1024, null: false
    t.text "description"
    t.citext "slug"
    t.string "website_url", limit: 1024
    t.string "nsuid", limit: 32
    t.string "external_id", limit: 256, null: false
    t.string "boxart_url", limit: 1024
    t.string "banner_url", limit: 1024
    t.string "release_date_display", limit: 64
    t.date "release_date"
    t.string "content_rating", limit: 64
    t.jsonb "extra", default: {}, null: false
    t.string "publishers", default: [], null: false, array: true
    t.string "developers", default: [], null: false, array: true
    t.string "genres", default: [], null: false, array: true
    t.string "franchises", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "on_sale", default: false, null: false
    t.boolean "new_release", default: false, null: false
    t.boolean "coming_soon", default: false, null: false
    t.boolean "pre_order", default: false, null: false
    t.integer "all_time_visits", default: 0, null: false
    t.integer "last_week_visits", default: 0, null: false
    t.integer "current_price_cents"
    t.string "current_price_currency", default: "BRL", null: false
    t.index ["all_time_visits"], name: "index_items_on_all_time_visits"
    t.index ["coming_soon"], name: "index_items_on_coming_soon", where: "coming_soon"
    t.index ["external_id"], name: "index_items_on_external_id", unique: true
    t.index ["last_week_visits"], name: "index_items_on_last_week_visits"
    t.index ["new_release"], name: "index_items_on_new_release", where: "new_release"
    t.index ["on_sale"], name: "index_items_on_on_sale", where: "on_sale"
    t.index ["pre_order"], name: "index_items_on_pre_order", where: "pre_order"
    t.index ["release_date"], name: "index_items_on_release_date"
  end

  create_table "price_history_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "price_id", null: false
    t.date "reference_date", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "BRL", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["price_id", "reference_date"], name: "index_price_history_items_on_price_id_and_reference_date", unique: true
    t.index ["price_id"], name: "index_price_history_items_on_price_id"
  end

  create_table "prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id", null: false
    t.string "nsuid", null: false
    t.integer "base_price_cents", default: 0, null: false
    t.string "base_price_currency", default: "BRL", null: false
    t.integer "discount_price_cents"
    t.string "discount_price_currency", default: "BRL", null: false
    t.datetime "discount_started_at"
    t.datetime "discount_ends_at"
    t.integer "discount_percentage"
    t.string "state", null: false
    t.integer "gold_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "discounted_amount_cents"
    t.string "discounted_amount_currency", default: "BRL", null: false
    t.index ["item_id"], name: "index_prices_on_item_id", unique: true
    t.index ["nsuid"], name: "index_prices_on_nsuid", unique: true
  end

  create_table "raw_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id"
    t.string "external_id", limit: 256, null: false
    t.jsonb "data", default: {}, null: false
    t.string "checksum", limit: 512, null: false
    t.boolean "imported", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_raw_items_on_external_id", unique: true
    t.index ["imported"], name: "index_raw_items_on_imported", where: "(imported = false)"
    t.index ["item_id"], name: "index_raw_items_on_item_id", unique: true, where: "(item_id IS NOT NULL)"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "profile_image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "wishlist_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_wishlist_items_on_item_id"
    t.index ["user_id", "item_id"], name: "index_wishlist_items_on_user_id_and_item_id", unique: true
    t.index ["user_id"], name: "index_wishlist_items_on_user_id"
  end

  add_foreign_key "event_dispatches", "item_events"
  add_foreign_key "hidden_items", "items"
  add_foreign_key "hidden_items", "users"
  add_foreign_key "price_history_items", "prices"
  add_foreign_key "prices", "items"
  add_foreign_key "raw_items", "items"
  add_foreign_key "wishlist_items", "items"
  add_foreign_key "wishlist_items", "users"
end
