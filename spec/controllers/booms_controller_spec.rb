require 'spec_helper'

describe BoomsController do

  def mock_boom(stubs={})
    (@mock_boom ||= mock_model(Boom).as_null_object).tap do |boom|
      boom.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all booms as @booms" do
      Boom.stub(:all) { [mock_boom] }
      get :index
      assigns(:booms).should eq([mock_boom])
    end
  end

  describe "GET show" do
    it "assigns the requested boom as @boom" do
      Boom.stub(:find).with("37") { mock_boom }
      get :show, :id => "37"
      assigns(:boom).should be(mock_boom)
    end
  end

  describe "GET new" do
    it "assigns a new boom as @boom" do
      Boom.stub(:new) { mock_boom }
      get :new
      assigns(:boom).should be(mock_boom)
    end
  end

  describe "GET edit" do
    it "assigns the requested boom as @boom" do
      Boom.stub(:find).with("37") { mock_boom }
      get :edit, :id => "37"
      assigns(:boom).should be(mock_boom)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created boom as @boom" do
        Boom.stub(:new).with({'these' => 'params'}) { mock_boom(:save => true) }
        post :create, :boom => {'these' => 'params'}
        assigns(:boom).should be(mock_boom)
      end

      it "redirects to the created boom" do
        Boom.stub(:new) { mock_boom(:save => true) }
        post :create, :boom => {}
        response.should redirect_to(boom_url(mock_boom))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved boom as @boom" do
        Boom.stub(:new).with({'these' => 'params'}) { mock_boom(:save => false) }
        post :create, :boom => {'these' => 'params'}
        assigns(:boom).should be(mock_boom)
      end

      it "re-renders the 'new' template" do
        Boom.stub(:new) { mock_boom(:save => false) }
        post :create, :boom => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested boom" do
        Boom.should_receive(:find).with("37") { mock_boom }
        mock_boom.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :boom => {'these' => 'params'}
      end

      it "assigns the requested boom as @boom" do
        Boom.stub(:find) { mock_boom(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:boom).should be(mock_boom)
      end

      it "redirects to the boom" do
        Boom.stub(:find) { mock_boom(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(boom_url(mock_boom))
      end
    end

    describe "with invalid params" do
      it "assigns the boom as @boom" do
        Boom.stub(:find) { mock_boom(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:boom).should be(mock_boom)
      end

      it "re-renders the 'edit' template" do
        Boom.stub(:find) { mock_boom(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested boom" do
      Boom.should_receive(:find).with("37") { mock_boom }
      mock_boom.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the booms list" do
      Boom.stub(:find) { mock_boom }
      delete :destroy, :id => "1"
      response.should redirect_to(booms_url)
    end
  end

end
