class SaleItem
  
  include DataMapper::Resource
  property :id,         Serial
  property :sku,        String
  property :name,       String
  property :sale_price,      Integer # store as cents
  property :original_price,  Integer # store as cents
  property :store_url,  String
  property :image_url,  String
  # TODO capture and store color in another model -> has n, :colors

  attr_accessor :raw_sale_price
  attr_accessor :raw_original_price
  
  
  before :save, :store_price_as_cents
  
  def store_price_as_cents
    self.sale_price = (raw_sale_price.gsub('$','').to_f * 100).to_i
    self.original_price = (raw_original_price.gsub('$','').to_f * 100).to_i
  end
  
  # def formatted_price
  #   "$%.2f" % (self.price/100.0)
  # end
  
end