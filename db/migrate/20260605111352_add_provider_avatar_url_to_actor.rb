class AddProviderAvatarUrlToActor < ActiveRecord::Migration[8.1]
  def change
    add_column :actors, :provider_avatar_url, :string
  end
end
