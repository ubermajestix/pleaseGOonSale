require 'spec_helper'

describe "SaleItem" do
   
   before(:each) do
     # @user = Fabricate(:user)
     @sale_item = Fabricate(:sale_item)
   end
   
   it "should require a raw sale price" do
     lambda{@sale_item.save!}.should_not raise_error
     sale_item2 = Fabricate(:sale_item)
     sale_item2.raw_sale_price = nil
     lambda{sale_item2.save!}.should raise_error
   end
  
  
end