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
    describe "#clean!" do
      before(:each) do
        @application = Factory(:application)
        @notifier    = Factory(:notifier, :application => @application)
      end
            
      it "removes notifications that have no statuses" do
        @notification_2 = Factory(:notification)
                  
        lambda {
          Notification.clean!
        }.should change(Notification, :count).by(-2)
        
        Notification.where(:_id => @notification.id  ).should_not be_present
        Notification.where(:_id => @notification_2.id).should_not be_present
      end
      
      it "removes notifications that have succesfully notified everyone" do
        @notification_2 = Factory(:notification)
        
        [@notification, @notification_2].each do |notification|
          notification.statuses.create(:application => @application, :state => 'processed', :notifier_id => @notifier.id)
        end
      
        lambda {
          Notification.clean!
        }.should change(Notification, :count).by(-2)
        
        Notification.where(:_id => @notification.id  ).should_not be_present
        Notification.where(:_id => @notification_2.id).should_not be_present       
      end
 
      it "does not remove notifications that have statuses that are not 'processed'" do
        @notification_2 = Factory(:notification)
        
        @notification.statuses.create(  :application => @application, :notifier_id => @notifier.id, :state => 'queued')
        @notification_2.statuses.create(:application => @application, :notifier_id => @notifier.id, :state => 'processed')
        
        lambda {
          Notification.clean!
        }.should change(Notification, :count).by(-1)
        
        Notification.where(:_id => @notification.id  ).should be_present
        Notification.where(:_id => @notification_2.id).should_not be_present        
      end
    end
    
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
