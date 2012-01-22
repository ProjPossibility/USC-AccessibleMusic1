class AddIndexIdentifierToFacebook < ActiveRecord::Migration
  def change
    add_index :facebooks, :identifier, :unique => true
  end
end
