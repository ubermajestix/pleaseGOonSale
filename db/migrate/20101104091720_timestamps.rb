class Timestamps < ActiveRecord::Migration
  def self.up
    change_table :users do |t| 
      t.timestamps 
    end 
    change_table :items do |t| 
      t.timestamps 
    end
    change_table :sale_items do |t| 
      t.timestamps 
    end
  end

  def self.down
  end
end
