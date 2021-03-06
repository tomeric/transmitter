require 'spec_helper'

describe NotificationsController do
  def mock_notification(stubs={})
    @mock_notification ||= mock_model(Notification, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all notifications as @notifications" do
      Notification.stub(:all) { [mock_notification] }
      get :index
      assigns(:notifications).should eq([mock_notification])
    end
  end

  describe "GET show" do
    it "assigns the requested notification as @notification" do
      Notification.stub(:find).with("37") { mock_notification }
      get :show, :id => "37"
      assigns(:notification).should be(mock_notification)
    end
  end

  describe "GET new" do  
    before(:each) do
      @application = Factory(:application)
    end
  
    it "assigns a new notification as @notification" do
      Notification.stub(:new) { mock_notification }
      get :new, :api_key => @application.api_key
      assigns(:notification).should be(mock_notification)
    end
  end

  describe "POST create" do
    before(:each) do
      @application = Factory(:application)
    end
    
    describe "with valid params" do
      it "assigns a newly created notification as @notification" do
        Notification.stub(:new).with({'these' => 'params'}) { mock_notification(:save => true) }
        post :create, :notification => {'these' => 'params'}, :api_key => @application.api_key
        assigns(:notification).should be(mock_notification)
      end

      it "redirects to the created notification" do
        Notification.stub(:new) { mock_notification(:save => true) }
        post :create, :notification => {}, :api_key => @application.api_key
        response.should redirect_to(notification_url(mock_notification))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved notification as @notification" do
        Notification.stub(:new).with({'these' => 'params'}) { mock_notification(:save => false) }
        post :create, :notification => {'these' => 'params'}, :api_key => @application.api_key
        assigns(:notification).should be(mock_notification)
      end

      it "re-renders the 'new' template" do
        Notification.stub(:new) { mock_notification(:save => false) }
        post :create, :notification => {}, :api_key => @application.api_key
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @application = Factory(:application)
    end

    it "destroys the requested notification" do
      Notification.stub(:find).and_return(mock_notification)
      mock_notification.should_receive(:destroy)
      delete :destroy, :id => "37", :api_key => @application.api_key
    end

    it "redirects to the notifications list" do
      Notification.stub(:find) { mock_notification }
      delete :destroy, :id => "1", :api_key => @application.api_key
      response.should redirect_to(notifications_url)
    end
  end

end
