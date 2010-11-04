require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Transactions" do
   
   # use_transactions
   
   it "should not have any records" do
     User.count.should == 0
   end
   
   it "should create one record" do
     u = Fabricate(:user)
     u.save!
     User.count.should == 1
   end
  
    it "should now have zero records" do
      User.count.should == 0
    end
  
end