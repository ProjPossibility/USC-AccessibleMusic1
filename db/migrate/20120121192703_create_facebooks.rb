class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks do |t|
      t.string :identifier
      t.string :access_token
      t.string :cell

      t.timestamps
    end
  end
end
