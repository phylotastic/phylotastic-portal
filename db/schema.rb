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

ActiveRecord::Schema.define(version: 20160208153932) do

  create_table "con_files", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "con_files", ["user_id"], name: "index_con_files_on_user_id"

  create_table "con_links", force: :cascade do |t|
    t.string   "uri"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "con_links", ["user_id"], name: "index_con_links_on_user_id"

  create_table "con_taxons", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "con_taxons", ["user_id"], name: "index_con_taxons_on_user_id"

  create_table "phylo_sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "raw_extractions", force: :cascade do |t|
    t.text     "species"
    t.integer  "contributable_id"
    t.string   "contributable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "raw_extractions", ["contributable_type", "contributable_id"], name: "index_raw_extraction_for_contributable"

  create_table "trees", force: :cascade do |t|
    t.boolean  "public",            default: false
    t.text     "chosen_species"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "branch_length"
    t.boolean  "images_from_EOL"
    t.string   "bg_job"
    t.string   "status"
    t.integer  "phylo_source_id"
    t.integer  "raw_extraction_id"
  end

  add_index "trees", ["bg_job"], name: "index_trees_on_bg_job"
  add_index "trees", ["phylo_source_id"], name: "index_trees_on_phylo_source_id"
  add_index "trees", ["raw_extraction_id"], name: "index_trees_on_raw_extraction_id"
  add_index "trees", ["user_id", "created_at"], name: "index_trees_on_user_id_and_created_at"
  add_index "trees", ["user_id"], name: "index_trees_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
