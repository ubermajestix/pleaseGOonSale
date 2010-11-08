require 'spec_helper'

describe "booms/edit.html.erb" do
  before(:each) do
    @boom = assign(:boom, stub_model(Boom,
      :new_record? => false
    ))
  end

  it "renders the edit boom form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => boom_path(@boom), :method => "post" do
    end
  end
end
