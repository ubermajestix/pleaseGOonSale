require 'spec_helper'

describe "Item" do
   
   before(:each) do
     @user = Fabricate(:user)
     @item = Fabricate(:item)
   end
   
  it "should find or create items and add it to a user unless that user already has that item" do
    @user.items.should be_empty
    @user.items << @item
    @user.items.should_not be_empty
    i2 = Item.find_or_create_by_sku(@item.sku, @item.attributes)
    Item.count.should == 1
    i2.should == @item
    lambda{u1.items << i2}.should raise_error
    @user.items.should == [@item]
  end
  
  it "should have a nice method to create an item and add it to a user" do
    item = Fabricate(:item)
    added_item = Item.add_item(item.attributes, @user)
    @user.items.should include(item)
    item.should == added_item
  end
  
  it "should tell me if i've added an item already" do
    item = Fabricate(:item)
    added_item = Item.add_item(item.attributes, @user)
    added_item2 = Item.add_item(item.attributes, @user)
    @user.items.length.should == 1
    added_item2.should == item
    added_item2.errors.should_not be_empty
    puts added_item2.errors.on_base.should == "This item is already on your rack!"
  end
  
  it "should remove item if no user is associated to it" do
    pending 'some kind of observer class or dependent destroy on the join model'
    Item.count.should == 1
    @user.items.should be_empty
    @user.items << @item
    @user.items.delete(@item)
    Item.count.should == 0
  end
  
  describe 'being on sale' do
    before(:each) do
      @sale_item = Fabricate(:sale_item, :sku=>@item.sku)
      @item2 = Fabricate(:item)
    end
    it "should know if its on sale" do
      @item.should be_on_sale
      @item2.should_not be_on_sale
    end
  
    it "should return the SaleItem object if its on sale" do
      @item.sale_item == @sale_item
      @item2.sale_item.should == nil
    end
  end
  
  
end