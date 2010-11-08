class Habtm < ActiveRecord::Migration
  def self.up
    create_table :my_racks do |t|
      t.integer :user_id
      t.integer :item_id
      t.timestamps
    end
    create_table :items_colors do |t|
      t.integer :color_id
      t.integer :item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users_items
    drop_table :items_colors
  end
end
