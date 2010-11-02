class Color < ActiveRecord::Base
  
  attr_accessor :swatch_url
  
  validates_presence_of :name, :hex, :sku
  # TODO validate hex is unique for a given sku
  
  before_validation :process_swatch
  
private
  
  def process_swatch
    i = ChunkyPNG::Image.from_io(open("http://www.anthropologie.com"<<self.swatch_url))
    self.hex = ChunkyPNG::Color.to_hex(i.get_pixel(2,2))[0,7]
  end
  
end


# class DMColor
#   include DataMapper::Resource
#   property :id,     Serial
#   property :name,   String
#   property :hex,    String
#   property :sku,    String
#   
#   # validates_with_method :unique_sku_and_hex
#   
#   attr_accessor :swatch_url
# 
#   before :save, :process_swatch
#   
#   def process_swatch
#     i = ChunkyPNG::Image.from_io(open("http://www.anthropologie.com"<<self.swatch_url))
#     self.hex = ChunkyPNG::Color.to_hex(i.get_pixel(2,2))[0,7]
#   end
#   
#   
#   # def unique_sku_and_hex
#   #   puts "="*45
#   #   puts self.inspect
#   #   puts "="*45
#   #   if Color.count(:sku=>self.sku, :hex => self.hex) == 0
#   #     return true
#   #   else
#   #     return [false, "color exists for sku"]
#   #   end
#   # end
# end