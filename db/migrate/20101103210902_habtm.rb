class Habtm < ActiveRecord::Migration
  def self.up
    create_table :users_items do |t|
      t.integer :user_id
      t.integer :item_id
      t.timestamps!
    end
    create_table :items_colors do |t|
      t.integer :color_id
      t.integer :item_id
      t.timestamps!
    end
    remove_column :items, :user_id
    remove_column :colors, :sku
  end

  def self.down
  end
end
