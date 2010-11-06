class SaleItem < ActiveRecord::Base
  
  attr_accessor  :raw_sale_price
  attr_accessor  :raw_original_price
  attr_accessor  :raw_colors

  before_save :store_price_as_cents
  before_save :process_colors
  
  has_many :colors, :foreign_key => :sku
  
  validates_presence_of :raw_sale_price
  
  def self.match
    sale_items = SaleItem.all
    items_on_sale = Item.all(:conditions=>["sku in (?)", sale_items.map(&:sku)])
    puts "="*45
    puts "found #{items_on_sale.length} customer saved items on sale"
    puts "="*45
  end
  
  def formatted_price
    "$%.2f" % (self.price/100.0)
  end
  
private
  
  def store_price_as_cents
    self.sale_price = (self.raw_sale_price.gsub('$','').to_f * 100).to_i
    self.original_price = (self.raw_original_price.gsub('$','').to_f * 100).to_i
  end
  
  def process_colors
    self.raw_colors.each do |color|
      self.colors << Color.create(color)
    end if self.raw_colors  
  end
  
end