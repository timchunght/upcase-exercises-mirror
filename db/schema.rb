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

ActiveRecord::Schema.define(version: 20140505191405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clones", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "exercise_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "parent_sha"
  end

  add_index "clones", ["exercise_id"], name: "index_clones_on_exercise_id", using: :btree
  add_index "clones", ["user_id", "exercise_id"], name: "index_clones_on_user_id_and_exercise_id", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "solution_id", null: false
    t.text     "text",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "comments", ["solution_id"], name: "index_comments_on_solution_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exercises", force: true do |t|
    t.string "title", null: false
    t.text   "body",  null: false
    t.string "slug",  null: false
  end

  add_index "exercises", ["slug"], name: "index_exercises_on_slug", unique: true, using: :btree

  create_table "public_keys", force: true do |t|
    t.integer  "user_id",    null: false
    t.text     "data",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "public_keys", ["user_id"], name: "index_public_keys_on_user_id", using: :btree

  create_table "revisions", force: true do |t|
    t.text     "diff"
    t.integer  "solution_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at"
  end

  add_index "revisions", ["created_at"], name: "index_revisions_on_created_at", using: :btree

  create_table "solutions", force: true do |t|
    t.integer  "clone_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "solutions", ["clone_id"], name: "index_solutions_on_clone_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.integer  "learn_uid",                                      null: false
    t.string   "auth_token",                                     null: false
    t.string   "first_name",                                     null: false
    t.string   "last_name",                                      null: false
    t.boolean  "subscriber",                     default: false, null: false
    t.boolean  "admin",                          default: false
    t.string   "username",                                       null: false
    t.string   "avatar_url",                                     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["learn_uid"], name: "index_users_on_learn_uid", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
