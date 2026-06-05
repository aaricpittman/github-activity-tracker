class RenameRepositoryIdOnPushEvents < ActiveRecord::Migration[8.1]
  def change
    rename_column :push_events, :repository_id, :provider_repository_id 
  end
end
