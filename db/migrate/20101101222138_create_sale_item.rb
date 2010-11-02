class CreateSaleItem < ActiveRecord::Migration
  def self.up
    create_table :sale_items do |t|
      t.string  :sku
      t.string  :name
      t.integer :sale_price
      t.integer :original_price
      t.string  :store_url
      t.string  :image_url
    end
  end

  def self.down
    drop_tables :sale_items
  end
end
