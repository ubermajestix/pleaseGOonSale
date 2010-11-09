class Item < ActiveRecord::Base

  attr_accessor  :raw_price
  attr_accessor  :raw_colors

  has_many :my_rack
  has_many :items_colors
  has_many :users, :through => :my_rack
  has_many :colors, :through => :items_colors
  
  validates_uniqueness_of :sku
  validates_presence_of :raw_price

  before_save :store_price_as_cents
  # before_save :process_colors
  
  
  def self.add_item(attrs, user)
    item = Item.find_or_create_by_sku(attrs['sku'], attrs)
    begin
      user.items << item
      item
    rescue StandardError => e
      puts e.inspect
      puts e.backtrace
      item.errors.add_to_base 'This item is already on your rack!'
      return item
    end
  end
  
  def on_sale?
    !!sale_item
  end
  
  def sale_item
    SaleItem.find_by_sku(sku)
  end
  
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
      self.colors << Color.create(color.last)
    end if self.raw_colors
  end
end