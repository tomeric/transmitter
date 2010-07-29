require 'spec_helper'

describe ApplicationsController do

  def mock_application(stubs={})
    @mock_application ||= mock_model(Application, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all applications as @applications" do
      Application.stub(:all) { [mock_application] }
      get :index
      assigns(:applications).should eq([mock_application])
    end
  end

  describe "GET show" do
    it "assigns the requested application as @application" do
      Application.stub(:find).with("37") { mock_application }
      get :show, :id => "37"
      assigns(:application).should be(mock_application)
    end
  end

  describe "GET new" do
    it "assigns a new application as @application" do
      Application.stub(:new) { mock_application }
      get :new
      assigns(:application).should be(mock_application)
    end
  end

  describe "GET edit" do
    it "assigns the requested application as @application" do
      Application.stub(:find).with("37") { mock_application }
      get :edit, :id => "37"
      assigns(:application).should be(mock_application)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created application as @application" do
        Application.stub(:new).with({'these' => 'params'}) { mock_application(:save => true) }
        post :create, :application => {'these' => 'params'}
        assigns(:application).should be(mock_application)
      end

      it "redirects to the created application" do
        Application.stub(:new) { mock_application(:save => true) }
        post :create, :application => {}
        response.should redirect_to(application_url(mock_application))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved application as @application" do
        Application.stub(:new).with({'these' => 'params'}) { mock_application(:save => false) }
        post :create, :application => {'these' => 'params'}
        assigns(:application).should be(mock_application)
      end

      it "re-renders the 'new' template" do
        Application.stub(:new) { mock_application(:save => false) }
        post :create, :application => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested application" do
        Application.should_receive(:find).with("37") { mock_application }
        mock_application.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :application => {'these' => 'params'}
      end

      it "assigns the requested application as @application" do
        Application.stub(:find) { mock_application(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:application).should be(mock_application)
      end

      it "redirects to the application" do
        Application.stub(:find) { mock_application(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(application_url(mock_application))
      end
    end

    describe "with invalid params" do
      it "assigns the application as @application" do
        Application.stub(:find) { mock_application(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:application).should be(mock_application)
      end

      it "re-renders the 'edit' template" do
        Application.stub(:find) { mock_application(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested application" do
      Application.should_receive(:find).with("37") { mock_application }
      mock_application.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the applications list" do
      Application.stub(:find) { mock_application }
      delete :destroy, :id => "1"
      response.should redirect_to(applications_url)
    end
  end
end
