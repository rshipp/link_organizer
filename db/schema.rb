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

ActiveRecord::Schema[7.1].define(version: 2024_08_15_200112) do
  create_table "links", force: :cascade do |t|
    t.string "url"
    t.string "source_url"
    t.text "comment"
    t.string "archive_url"
    t.text "text"
    t.datetime "published_at"
    t.string "title"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
    t.integer "rating"
    t.index ["url"], name: "index_links_on_url", unique: true
  end

  create_table "links_tags", force: :cascade do |t|
    t.integer "link_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "tag_id"], name: "index_links_tags_on_link_id_and_tag_id", unique: true
    t.index ["link_id"], name: "index_links_tags_on_link_id"
    t.index ["tag_id"], name: "index_links_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "links_tags", "links"
  add_foreign_key "links_tags", "tags"
end
