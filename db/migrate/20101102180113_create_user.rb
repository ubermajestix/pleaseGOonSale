class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password
      t.string :confirmation_code
      t.boolean :has_confirmed, :default => false
    end 
  end

  def self.down
  end
end
