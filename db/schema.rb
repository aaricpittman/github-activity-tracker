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

ActiveRecord::Schema[8.1].define(version: 2026_06_05_192735) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actors", force: :cascade do |t|
    t.string "blog"
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "follower_count"
    t.integer "following_count"
    t.boolean "hireable"
    t.string "location"
    t.string "login"
    t.string "name"
    t.string "profile_url"
    t.string "provider_avatar_url"
    t.datetime "provider_created_at"
    t.bigint "provider_id", null: false
    t.datetime "provider_updated_at"
    t.integer "public_repo_count"
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_actors_on_provider_id", unique: true
  end

  create_table "push_events", force: :cascade do |t|
    t.integer "actor_id"
    t.string "before", null: false
    t.datetime "created_at", null: false
    t.string "head", null: false
    t.json "payload", null: false
    t.string "provider_id", null: false
    t.bigint "provider_repository_id", null: false
    t.bigint "push_id", null: false
    t.datetime "pushed_at"
    t.string "ref", null: false
    t.integer "repo_id"
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_push_events_on_actor_id"
    t.index ["provider_id"], name: "index_push_events_on_provider_id", unique: true
    t.index ["repo_id"], name: "index_push_events_on_repo_id"
  end

  create_table "repos", force: :cascade do |t|
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.string "default_branch"
    t.boolean "disabled"
    t.integer "fork_count", default: 0
    t.boolean "has_discussions"
    t.boolean "has_downloads"
    t.boolean "has_issues"
    t.boolean "has_pages"
    t.boolean "has_projects"
    t.boolean "has_pull_requests"
    t.boolean "has_wiki"
    t.string "language"
    t.string "license"
    t.string "name"
    t.integer "network_count", default: 0
    t.integer "open_issue_count", default: 0
    t.integer "open_issues_count", default: 0
    t.datetime "provider_created_at"
    t.bigint "provider_id", null: false
    t.datetime "provider_pushed_at"
    t.datetime "provider_updated_at"
    t.integer "stargazers_count", default: 0
    t.integer "subscribers_count", default: 0
    t.string "topics", array: true
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "watchers_count", default: 0
    t.index ["provider_id"], name: "index_repos_on_provider_id", unique: true
  end

  create_table "webhooks_github_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "github_event_id", null: false
    t.json "payload", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["github_event_id"], name: "index_webhooks_github_events_on_github_event_id", unique: true
    t.index ["status"], name: "index_webhooks_github_events_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
