require "spec_helper"

describe Notify do
  before(:each) do
    @user = Fabricate(:user)
    @item = Fabricate(:item)
    @sale_item = Fabricate(:sale_item, :sku=>@item.sku)
  end
  
  it "should notify user of a sale" do
    email = Notify.sale_email(@user, [@sale_item])
    ActionMailer::Base.deliveries.should be_empty
    email.to.first.should == @user.email
    email.deliver
    ActionMailer::Base.deliveries.should_not be_empty
  end
  
  it "should set the host" do
    email = Notify.sale_email(@user, [@sale_item])
    email.body.should_not match(/pleasegoonsale.heroku.com/)
    email.body.should match(/localhost:3000/)
  end
end
