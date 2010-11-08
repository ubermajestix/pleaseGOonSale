require 'spec_helper'

describe "booms/new.html.erb" do
  before(:each) do
    assign(:boom, stub_model(Boom).as_new_record)
  end

  it "renders new boom form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => booms_path, :method => "post" do
    end
  end
end
