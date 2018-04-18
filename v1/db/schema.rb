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

ActiveRecord::Schema.define(version: 20170921083412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cloning_relationships", force: :cascade do |t|
    t.integer  "parent"
    t.integer  "child"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cloning_relationships", ["child"], name: "index_cloning_relationships_on_child", using: :btree
  add_index "cloning_relationships", ["parent"], name: "index_cloning_relationships_on_parent", using: :btree

  create_table "con_files", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "method"
  end

  add_index "con_files", ["description"], name: "index_con_files_on_description", using: :btree
  add_index "con_files", ["name"], name: "index_con_files_on_name", using: :btree
  add_index "con_files", ["user_id"], name: "index_con_files_on_user_id", using: :btree

  create_table "con_links", force: :cascade do |t|
    t.string   "uri"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "description"
  end

  add_index "con_links", ["description"], name: "index_con_links_on_description", using: :btree
  add_index "con_links", ["name"], name: "index_con_links_on_name", using: :btree
  add_index "con_links", ["user_id"], name: "index_con_links_on_user_id", using: :btree

  create_table "con_taxons", force: :cascade do |t|
    t.string   "taxon"
    t.string   "name"
    t.boolean  "has_genome_in_ncbi"
    t.integer  "nb_species"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "country_id"
    t.string   "reason"
  end

  add_index "con_taxons", ["country_id"], name: "index_con_taxons_on_country_id", using: :btree
  add_index "con_taxons", ["description"], name: "index_con_taxons_on_description", using: :btree
  add_index "con_taxons", ["name"], name: "index_con_taxons_on_name", using: :btree
  add_index "con_taxons", ["user_id"], name: "index_con_taxons_on_user_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "onpl_files", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "onpl_files", ["description"], name: "index_onpl_files_on_description", using: :btree
  add_index "onpl_files", ["name"], name: "index_onpl_files_on_name", using: :btree
  add_index "onpl_files", ["user_id"], name: "index_onpl_files_on_user_id", using: :btree

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
    t.text     "extracted_names"
    t.string   "temp_id"
    t.integer  "user_id"
  end

  add_index "raw_extractions", ["contributable_type", "contributable_id"], name: "index_raw_extraction_for_contributable", using: :btree
  add_index "raw_extractions", ["temp_id"], name: "index_raw_extractions_on_temp_id", using: :btree

  create_table "trees", force: :cascade do |t|
    t.boolean  "public",                    default: false
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
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "representation"
    t.text     "description"
    t.boolean  "notifiable",                default: true
    t.string   "name"
    t.string   "temp_id"
    t.string   "action_sequence"
    t.text     "scaled_representation"
    t.text     "scaled_sdm_representation"
  end

  add_index "trees", ["bg_job"], name: "index_trees_on_bg_job", using: :btree
  add_index "trees", ["name"], name: "index_trees_on_name", using: :btree
  add_index "trees", ["phylo_source_id"], name: "index_trees_on_phylo_source_id", using: :btree
  add_index "trees", ["raw_extraction_id"], name: "index_trees_on_raw_extraction_id", using: :btree
  add_index "trees", ["temp_id"], name: "index_trees_on_temp_id", using: :btree
  add_index "trees", ["user_id", "created_at"], name: "index_trees_on_user_id_and_created_at", using: :btree
  add_index "trees", ["user_id"], name: "index_trees_on_user_id", using: :btree

  create_table "uploaded_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.boolean  "public",            default: false
    t.boolean  "status"
    t.integer  "lid"
    t.string   "reason"
    t.string   "name"
    t.text     "description"
  end

  add_index "uploaded_lists", ["description"], name: "index_uploaded_lists_on_description", using: :btree
  add_index "uploaded_lists", ["lid"], name: "index_uploaded_lists_on_lid", using: :btree
  add_index "uploaded_lists", ["name"], name: "index_uploaded_lists_on_name", using: :btree
  add_index "uploaded_lists", ["user_id"], name: "index_uploaded_lists_on_user_id", using: :btree

  create_table "user_list_relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "uploaded_list_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_list_relationships", ["uploaded_list_id"], name: "index_user_list_relationships_on_uploaded_list_id", using: :btree
  add_index "user_list_relationships", ["user_id", "uploaded_list_id"], name: "index_user_list_relationships_on_user_id_and_uploaded_list_id", unique: true, using: :btree
  add_index "user_list_relationships", ["user_id"], name: "index_user_list_relationships_on_user_id", using: :btree

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
    t.string   "provider"
    t.string   "uid"
    t.string   "refresh_token"
    t.string   "access_token"
    t.integer  "expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "watch_relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tree_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "watch_relationships", ["tree_id"], name: "index_watch_relationships_on_tree_id", using: :btree
  add_index "watch_relationships", ["user_id", "tree_id"], name: "index_watch_relationships_on_user_id_and_tree_id", unique: true, using: :btree
  add_index "watch_relationships", ["user_id"], name: "index_watch_relationships_on_user_id", using: :btree

  add_foreign_key "con_files", "users"
  add_foreign_key "con_links", "users"
  add_foreign_key "con_taxons", "countries"
  add_foreign_key "con_taxons", "users"
  add_foreign_key "onpl_files", "users"
  add_foreign_key "trees", "phylo_sources"
  add_foreign_key "trees", "raw_extractions"
  add_foreign_key "trees", "users"
  add_foreign_key "uploaded_lists", "users"
end
