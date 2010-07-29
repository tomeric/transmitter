require 'spec_helper'

describe Notification do
  before(:each) do
    @notification = Factory(:notification)
  end
  
  describe "associations" do
    it { should embed_many :statuses       }
    it { should reference_one :application }
  end
  
  describe "validations" do
    it { should validate_presence_of :queue }
  end
  
  describe "class methods" do
    describe "#notify_applications" do
      before(:each) do
        @notification.update_attributes(:queue => 'this_queue')
      end
      
      it "notifies applications that have a notifier set up for the specified queue" do
        @application = Factory(:application)
        @application.notifiers.create!(:queue => 'this_queue', :endpoint => Faker::Internet.url)
        
        Navvy::Job.should_receive(:enqueue).with(Application, :notify, @application.id, anything)
        Notification.notify_applications(@notification.id)
      end
      
      it "does not notify applications that do not have a notifier set up for the specified queue" do
        @application = Factory(:application)
        @application.notifiers.create!(:queue => 'other_queue', :endpoint => Faker::Internet.url)
        
        Navvy::Job.should_not_receive(:enqueue).with(Application, :notify, anything, anything)        
        Notification.notify_applications(@notification.id)
      end
    end
  end
  
  describe "creation" do
    it "creates a Navvy::Job" do
      @notification = Factory.build(:notification)
      
      lambda {
        @notification.save
      }.should change(Navvy::Job, :count).by(1)
    end
    
    it "enqueues Notification#notify_applications" do
      Navvy::Job.should_receive(:enqueue).with(Notification, :notify_applications, anything)
      
      @notification = Factory.build(:notification)
      @notification.save
    end
  end
end
