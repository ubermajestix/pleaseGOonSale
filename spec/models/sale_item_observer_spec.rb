require 'spec_helper'

describe SaleItemObserver do
  before(:each) do
    @user = Fabricate(:user)
    @item = Fabricate(:item)
    @item_2 = Fabricate(:item)
    @user.items << @item_2
    @observer = SaleItemObserver.instance
  end
  
  it "should not send email for an sale_item/item combo not on a rack" do
    sale_item = Fabricate(:sale_item, :sku=>@item.sku)
    @observer.after_create(sale_item)
    ActionMailer::Base.deliveries.should be_empty
  end
  
  it "send email for an item on a rack" do
    sale_item = Fabricate(:sale_item, :sku=>@item_2.sku)
     @observer.after_create(sale_item)
    ActionMailer::Base.deliveries.should_not be_empty
  end
  
  it "should not send email for sale items with no matching sku in items" do
    sale_item = Fabricate(:sale_item)
    @observer.after_create(sale_item)
    ActionMailer::Base.deliveries.should_not be_empty
  end
end
