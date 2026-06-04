class CreatePushEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :push_events do |t|
      t.string :provider_id, null: false
      t.bigint :repository_id, null: false
      t.bigint :push_id, null: false
      t.string :ref, null: false
      t.string :head, null: false
      t.string :before, null: false
      t.json :payload, null: false
      t.timestamps
    end

    add_index :push_events, [:provider_id], unique: true
  end
end
