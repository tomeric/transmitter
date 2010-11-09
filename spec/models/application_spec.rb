require 'spec_helper'

describe Application do
  before(:each) do
    @application = Factory(:application)
  end
  
  describe "associations" do
    it { should embed_many :notifiers         }
    it { should be_referenced_in :status      }
    it { should reference_many :notifications }
  end
  
  describe "validations" do
    it { should validate_presence_of :name             }
    it { should validate_length_of :api_key, :is => 40 }
    it { should validate_uniqueness_of :api_key        }
  end
  
  describe "instance methods" do
    describe "#notify_later" do      
      before(:each) do
        @endpoint = 'http://localhost/endpoint'
        @message  = 'the message'
      end
  
      it "starts delivery of notifications to notifiers in the same queue as the notification" do
        @notifier = @application.notifiers.create(:queue => 'this_queue', :endpoint => @endpoint)
        @notification = Factory(:notification, :queue => 'this_queue', :message => @message)
        
        Navvy::Job.should_receive(:enqueue).with(Notifier, :deliver, @application.id, @notifier.id, @notification.id)
        
        @application.notify_later(@notification)      
      end
      
      it "does not start delivery of notifications to notifiers in  a different queue as the notification" do
        @notifier = @application.notifiers.create(:queue => 'other_queue', :endpoint => @endpoint)
        @notification = Factory(:notification, :queue => 'this_queue', :message => @message)
        
        Navvy::Job.should_not_receive(:enqueue).with(Notifier, :deliver, anything, anything, anything)
        
        @application.notify_later(@notification)
      end      
    end
  end
  
  describe "creation" do
    it "generates an api key if it not set" do
      @application = Factory.build(:application)
      @application.api_key.should be_nil

      @application.save
      @application.api_key.should_not be_nil
    end
    
    it "does not overwrite an API key if it is set" do
      api_key = 'API-KEY-' * 5 # 40 chars
      
      @application = Factory.build(:application)
      @application.api_key = api_key
      @application.save
      
      @application.api_key.should eql(api_key)
    end
  end
end
