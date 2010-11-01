class Item
  
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer
  property :sku,        String
  property :name,       String
  property :price,      Integer # store as cents
  property :store_url,  String
  property :image_url,  String

  has n, :colors, :child_key => [:sku], :parent_key => [:sku]

  attr_accessor :raw_price
  attr_accessor :raw_colors
  
  # validates_uniqueness_of :sku
  
  before :save, :store_price_as_cents
  before :save, :process_colors
  
  def store_price_as_cents
    self.price = (raw_price.gsub('$','').to_f * 100).to_i
  end
  
  def process_colors
    self.raw_colors.each do |color|
      color.last['sku'] = self.sku
      c = Color.create(color.last)
      puts "="*45
      puts c.inspect
      puts "="*45
      # puts c.save
    end
  end
  
  def formatted_price
    "$%.2f" % (self.price/100.0)
  end
  
end