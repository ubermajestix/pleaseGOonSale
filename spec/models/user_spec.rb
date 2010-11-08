require 'spec_helper'

describe "User" do
   
   before(:each) do
   end
   
   it "should have the same length token everytime" do
     20.times do
       u = Fabricate(:user)
       u.save!  
       puts u.inspect
       u.authentication_token.should_not be_nil
       u.authentication_token.length.should == 20
     end
   end
  
  
end