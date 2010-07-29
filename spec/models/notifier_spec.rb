require 'spec_helper'

describe Notifier do
  before(:each) do
    @notifier = Factory(:notifier)
  end
  
  describe "associations" do
    it { should be_embedded_in :application }
  end
  
  describe "validations" do
    it { should validate_presence_of :queue    }
    it { should validate_presence_of :endpoint }
    
    it "ensures that the endpoint is a valid URL" do
      @notifier.should be_valid
      @notifier.endpoint = 'invalid url'
      @notifier.should_not be_valid
    end
  end
  
  describe "class methods" do
    describe "#deliver" do
      def http_success
        @http_success ||= mock(Net::HTTPSuccess, :code => 200)
      end
      
      def http_error
        @http_error ||= mock(Net::HTTPServerError, :code => 500)
      end
      
      before(:each) do
        @application  = @notifier.application
        @notification = Factory(:notification, :queue => @notifier.queue)
        @notifier.deliver_later(@notification)
      end
            
      it "updates the status to 'processed' when the delivery finishes" do
        HTTParty.stub(:post).and_return(http_success)
        Notifier.deliver(@application.id, @notifier.id, @notification.id)
        
        @notification.reload
        status = @notification.statuses.where(:notifier_id => @notifier.id.to_s).first
        status.should be_processed
      end
      
      it "raises an exception when the delivery fails" do
        HTTParty.stub(:post).and_return(http_error)
        
        lambda {
          Notifier.deliver(@application.id, @notifier.id, @notification.id)
        }.should raise_error
        
        @notification.reload
        status = @notification.statuses.where(:notifier_id => @notifier.id.to_s).first
        status.should be_failed        
      end
      
      it "updates the status to 'failed' when the delivery fails" do
        HTTParty.stub(:post).and_return(http_error)
        Notifier.deliver(@application.id, @notifier.id, @notification.id) rescue nil
        
        @notification.reload
        status = @notification.statuses.where(:notifier_id => @notifier.id.to_s).first
        status.should be_failed
      end
      
      it "raises an exception when the delivery raises an exception" do
        HTTParty.stub(:post).and_raise("exception")

        lambda {
          Notifier.deliver(@application.id, @notifier.id, @notification.id)
        }.should raise_error
      end
      
      it "updates the status to 'failed' when the delivery raises an exception" do
        HTTParty.stub(:post).and_raise("exception")
        Notifier.deliver(@application.id, @notifier.id, @notification.id) rescue nil
        
        @notification.reload
        status = @notification.statuses.where(:notifier_id => @notifier.id.to_s).first
        status.should be_failed        
      end
    end
  end
  
  describe "instance methods" do
    describe "#deliver_later" do
      before(:each) do
        @notification = Factory(:notification)
      end
      
      it "creates a notification status" do
        lambda {
          @notifier.deliver_later(@notification)
        }.should change(@notification.statuses, :count).by(1)       
      end
      
      it "should have a notification status that is queued" do
        @notifier.deliver_later(@notification)
        @notification.statuses.any? { |status| status.queued? }.should be_true
      end
    end
  end
end
