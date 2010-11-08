require "spec_helper"

describe BoomsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/booms" }.should route_to(:controller => "booms", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/booms/new" }.should route_to(:controller => "booms", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/booms/1" }.should route_to(:controller => "booms", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/booms/1/edit" }.should route_to(:controller => "booms", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/booms" }.should route_to(:controller => "booms", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/booms/1" }.should route_to(:controller => "booms", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/booms/1" }.should route_to(:controller => "booms", :action => "destroy", :id => "1")
    end

  end
end
