class CreateColor < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string :name
      t.string :hex
      t.timestamps 
    end
  end

  def self.down
    drop_table :colors
  end
end
