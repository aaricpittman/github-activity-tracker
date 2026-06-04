class CreateActors < ActiveRecord::Migration[8.1]
  def change
    create_table :actors do |t|
      t.bigint :provider_id, null: false
      t.datetime :provider_created_at
      t.datetime :provider_updated_at
      t.string :login
      t.string :profile_url
      t.string :name
      t.string :company
      t.string :blog
      t.string :location
      t.string :email
      t.boolean :hireable
      t.integer :public_repo_count
      t.integer :follower_count
      t.integer :following_count
      t.timestamps
    end

    add_index :actors, [:provider_id], unique: true
  end
end
