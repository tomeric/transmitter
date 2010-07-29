require 'spec_helper'

describe NotifiersController do
  def mock_notifiers(stubs = {})
    @mock_notifiers ||= mock_model(Notifier, stubs).as_null_object
  end

  def mock_notifier(stubs={})
    @mock_notifier ||= mock_model(Notifier, stubs).as_null_object
  end
  
  def mock_application(stubs = {})
    @mock_application ||= mock_model(Application, stubs).as_null_object
  end
  
  before(:each) do
    Application.stub(:find).with("1") { mock_application(:notifiers => mock_notifiers) }
  end

  describe "GET new" do
    it "assigns a new notifier as @notifier" do
      mock_notifiers.stub(:new) { mock_notifier }
      get :new, :application_id => "1"
      assigns(:notifier).should be(mock_notifier)
    end
  end

  describe "GET edit" do
    it "assigns the requested notifier as @notifier" do
      mock_notifiers.stub(:find).with("37") { mock_notifier }
      get :edit, :application_id => "1", :id => "37"
      assigns(:notifier).should be(mock_notifier)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created notifier as @notifier" do
        mock_notifiers.stub(:create).with({'these' => 'params'}) { mock_notifier(:valid? => true) }
        post :create, :application_id => "1", :notifier => {'these' => 'params'}
        assigns(:notifier).should be(mock_notifier)
      end

      it "redirects to the application" do
        mock_notifiers.stub(:create) { mock_notifier(:valid? => true) }
        post :create, :application_id => "1", :notifier => {}
        response.should redirect_to(application_url(mock_application))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved notifier as @notifier" do
        mock_notifiers.stub(:create).with({'these' => 'params'}) { mock_notifier(:valid? => false) }
        post :create, :application_id => "1", :notifier => {'these' => 'params'}
        assigns(:notifier).should be(mock_notifier)
      end

      it "re-renders the 'new' template" do
        mock_notifiers.stub(:create) { mock_notifier(:valid? => false) }
        post :create, :application_id => "1", :notifier => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested notifier" do
        mock_notifiers.should_receive(:find).with("37") { mock_notifier }
        mock_notifier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :application_id => "1", :id => "37", :notifier => {'these' => 'params'}
      end

      it "assigns the requested notifier as @notifier" do
        mock_notifiers.stub(:find) { mock_notifier(:update_attributes => true) }
        put :update, :application_id => "1", :id => "1"
        assigns(:notifier).should be(mock_notifier)
      end

      it "redirects to the application" do
        mock_notifiers.stub(:find) { mock_notifier(:update_attributes => true) }
        put :update, :application_id => "1", :id => "1"
        response.should redirect_to(application_url(mock_application))
      end
    end

    describe "with invalid params" do
      it "assigns the notifier as @notifier" do
        mock_notifiers.stub(:find) { mock_notifier(:update_attributes => false) }
        put :update, :application_id => "1", :id => "1"
        assigns(:notifier).should be(mock_notifier)
      end

      it "re-renders the 'edit' template" do
        mock_notifiers.stub(:find) { mock_notifier(:update_attributes => false) }
        put :update, :application_id => "1", :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested notifier" do
      mock_notifiers.should_receive(:find).with("37") { mock_notifier }
      mock_notifier.should_receive(:destroy)
      delete :destroy, :application_id => "1", :id => "37"
    end

    it "redirects to the application" do
      mock_notifiers.stub(:find) { mock_notifier }
      delete :destroy, :application_id => "1", :id => "1"
      response.should redirect_to(application_url(mock_application))
    end
  end
end
