require "spec_helper"

describe NotificationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/notifications" }.should route_to(:controller => "notifications", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/notifications/new" }.should route_to(:controller => "notifications", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/notifications/1" }.should route_to(:controller => "notifications", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/notifications" }.should route_to(:controller => "notifications", :action => "create")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/notifications/1" }.should route_to(:controller => "notifications", :action => "destroy", :id => "1")
    end
  end
end
