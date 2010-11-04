require 'open-uri' # so we can stream the swatch file
class Color < ActiveRecord::Base
  
  attr_accessor :swatch_url
  
  validates_presence_of :name, :hex, :sku
  # TODO validate hex is unique for a given sku
  
  before_validation :process_swatch
  
  has_many :items, :through => :items_colors
  
  
private
  
  def process_swatch
    i = ChunkyPNG::Image.from_io(open("http://www.anthropologie.com"<<self.swatch_url))
    self.hex = ChunkyPNG::Color.to_hex(i.get_pixel(2,2))[0,7]
  end
  
end