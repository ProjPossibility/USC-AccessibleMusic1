class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.references :facebook

      t.timestamps
    end
    add_index :playlists, :facebook_id
  end
end
