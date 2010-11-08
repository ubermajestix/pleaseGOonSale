require 'spec_helper'

describe "booms/show.html.erb" do
  before(:each) do
    @boom = assign(:boom, stub_model(Boom))
  end

  it "renders attributes in <p>" do
    render
  end
end
