class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :tinysong_id
      t.references :playlist

      t.timestamps
    end
    add_index :songs, :playlist_id
  end
end
