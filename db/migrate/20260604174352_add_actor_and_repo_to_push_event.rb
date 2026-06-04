class AddActorAndRepoToPushEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :push_events, :actor_id, :integer
    add_column :push_events, :repo_id, :integer
    add_index :push_events, [:actor_id]
    add_index :push_events, [:repo_id]
  end
end
