class SaleItem < ActiveRecord::Base
  
  attr_accessor  :raw_sale_price
  attr_accessor  :raw_original_price
  attr_accessor  :raw_colors

  before_save :store_price_as_cents
  before_save :process_colors
  
  has_many :colors, :foreign_key => :sku
  
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
      color['sku'] = self.sku
      self.colors << Color.create(color)
    end
  end
  
end