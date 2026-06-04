class CreateRepos < ActiveRecord::Migration[8.1]
  def change
    create_table :repos do |t|
      t.bigint :provider_id, null: false
      t.datetime :provider_created_at
      t.datetime :provider_updated_at
      t.datetime :provider_pushed_at
      t.string :name
      t.string :default_branch
      t.string :url
      t.string :language
      t.string :license
      t.string :topics, array: true
      t.boolean :has_issues
      t.boolean :has_projects
      t.boolean :has_downloads
      t.boolean :has_wiki
      t.boolean :has_pages
      t.boolean :has_discussions
      t.boolean :archived
      t.boolean :disabled
      t.boolean :has_pull_requests
      t.integer :open_issues_count, default: 0
      t.integer :fork_count, default: 0
      t.integer :open_issue_count, default: 0
      t.integer :network_count, default: 0
      t.integer :subscribers_count, default: 0
      t.integer :stargazers_count, default: 0
      t.integer :watchers_count, default: 0
      t.timestamps
    end

    add_index :repos, [:provider_id], unique: true
  end
end
