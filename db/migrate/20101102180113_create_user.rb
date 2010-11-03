class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password
      t.string :confirmation_code
      t.boolean :has_confirmed, :default => false
    end 
    User.create(:name=>'tyler', :email=>"tyler.a.montgomery@gmail.com", :password=>'boom1!', :has_confirmed=>true) 
  end

  def self.down
  end
end
