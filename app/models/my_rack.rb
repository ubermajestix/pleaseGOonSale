class MyRack < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  validates_uniqueness_of :item_id, :scope => :user_id, :message => "This item is already on your rack!"
  
end