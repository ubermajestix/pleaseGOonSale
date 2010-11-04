require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cruding Items" do
   
   before(:each) do
     ActiveRecord::Base.connection.increment_open_transactions
     ActiveRecord::Base.connection.transaction_joinable = false
     ActiveRecord::Base.connection.begin_db_transaction
     @u1 = Fabricate(:user)
     @i1 = Fabricate(:item)
   end

   after(:each) do
     ActiveRecord::Base.connection.rollback_db_transaction
     ActiveRecord::Base.connection.decrement_open_transactions
   end
   
  it "should find or create items and add it to a user unless that user already has that item" do
    @u1.items.should be_empty
    @u1.items << @i1
    @u1.items.should_not be_empty
    i2 = Item.find_or_create_by_sku(@i1.sku, @i1.attributes)
    Item.count.should == 1
    i2.should == @i1
    lambda{u1.items << i2}.should raise_error
    @u1.items.should == [@i1]
  end
  
  it "should remove item if no user is associated to it" do
    Item.count.should == 1
    @u1.items.should be_empty
    @u1.items << @i1
    @u1.items.delete(@i1)
    Item.count.should == 0
    # pending 'some kind of observer class or dependent destroy on the join model'
  end
  
  it "should know if its on sale" do
    pending 'migration to add :on_sale column'
  end
  
  
  
end