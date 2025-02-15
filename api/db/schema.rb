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

ActiveRecord::Schema[7.0].define(version: 2023_12_24_163100) do
  create_table "battles", force: :cascade do |t|
    t.integer "monsterA_id"
    t.integer "monsterB_id"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monsterA_id"], name: "index_battles_on_monsterA_id"
    t.index ["monsterB_id"], name: "index_battles_on_monsterB_id"
    t.index ["winner_id"], name: "index_battles_on_winner_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "imageUrl"
    t.integer "attack"
    t.integer "defense"
    t.integer "hp"
    t.integer "speed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

end
