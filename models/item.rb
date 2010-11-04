class Item < ActiveRecord::Base

  attr_accessor  :raw_price
  attr_accessor  :raw_colors

  has_many :users_item
  has_many :items_colors
  has_many :users, :through => :users_item
  has_many :colors, :through => :items_colors
  
  validates_uniqueness_of :sku,  :message => "This item is already on your rack!"

  before_save :store_price_as_cents
  before_save :process_colors
  
  
  def formatted_price
    "$%.2f" % (self.price/100.0)
  end
  
private
  
  def store_price_as_cents
    self.price = (self.raw_price.gsub('$','').to_f * 100).to_i
  end
  
  def process_colors
    #TODO send raw_colors as an array of hashes
    self.raw_colors.each do |color|
      color.last['sku'] = self.sku
      self.colors << Color.create(color.last)
    end if self.raw_colors
  end
end