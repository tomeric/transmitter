require "spec_helper"

describe NotifiersController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "/applications/1/notifiers/new" }.should route_to(:controller => "notifiers", :action => "new", :application_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/applications/1/notifiers/1/edit" }.should route_to(:controller => "notifiers", :action => "edit", :id => "1", :application_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/applications/1/notifiers" }.should route_to(:controller => "notifiers", :action => "create", :application_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/applications/1/notifiers/1" }.should route_to(:controller => "notifiers", :action => "update", :id => "1", :application_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/applications/1/notifiers/1" }.should route_to(:controller => "notifiers", :action => "destroy", :id => "1", :application_id => "1")
    end

  end
end
