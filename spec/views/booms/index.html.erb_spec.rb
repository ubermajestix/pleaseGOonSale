require 'spec_helper'

describe "booms/index.html.erb" do
  before(:each) do
    assign(:booms, [
      stub_model(Boom),
      stub_model(Boom)
    ])
  end

  it "renders a list of booms" do
    render
  end
end
