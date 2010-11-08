class CreateItem < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :sku
      t.string :name
      t.integer :price
      t.string :store_url
      t.string :image_url
      t.integer :user_id
      t.timestamps 
      
    end
  end

  def self.down
    drop_table :items
  end
end
