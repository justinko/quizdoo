class AddUsername < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_index :users, :username
  end

  def self.down
    remove_index :users, :username
    remove_column :users, :username
  end
end
