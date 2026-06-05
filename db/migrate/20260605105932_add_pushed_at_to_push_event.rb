class AddPushedAtToPushEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :push_events, :pushed_at, :datetime
  end
end
