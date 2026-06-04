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

ActiveRecord::Schema[8.1].define(version: 2026_06_04_174352) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.bigint "push_id", null: false
    t.string "ref", null: false
    t.integer "repo_id"
    t.bigint "repository_id", null: false
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
end
