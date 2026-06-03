class CreateWebhooksGithubEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :webhooks_github_events do |t|
      t.string :github_event_id, null: false
      t.column :status, :integer, default: 0
      t.json :payload, null: false
      t.timestamps
    end

    add_index :webhooks_github_events, [:github_event_id], unique: true
    add_index :webhooks_github_events, [:status]
  end
end
