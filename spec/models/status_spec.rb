require 'spec_helper'

describe Status do
  before(:each) do
    @status = Factory(:status)
  end
  
  describe "associations" do
    it { should be_embedded_in :notification }
    it { should reference_one :application   }
  end
  
  describe "validations" do
    it { should validate_presence_of(:application)  }
    it { should validate_presence_of(:notifier_id)  }
  end
  
  describe "states" do
    describe "queued" do
      it "has the 'queued' state after create" do
        @status.should be_queued
      end
      
      it "has the #start! method to progress to the 'in_progress' state" do
        @status.start!
        @status.should be_in_progress
      end
    end
    
    describe "in_progress" do
      it "does not have the 'in_progress' state after create" do
        @status.should_not be_in_progress
      end
      
      it "has the #close! method to progress to the 'processed' state" do
        @status.update_attributes(:state => 'in_progress')
        @status.close!
        @status.should be_processed
      end
      
      it "has the #fail! method to progress to the 'failed' state" do
        @status.update_attributes(:state => 'in_progress')
        @status.fail!
        @status.should be_failed
      end
    end
    
    describe "failed" do
      it "does not have the 'failed' state after create" do
        @status.should_not be_failed
      end
      
      it "has the #start! method to progress to the 'in_progress' state" do
        @status.update_attributes(:state => 'failed')
        @status.start!
        @status.should be_in_progress
      end
    end
    
    describe "processed" do
      it "does not have the 'processed' state after create" do
        @status.should_not be_processed
      end
    end
  end
  
  describe "instance methods" do
    describe "#notifier" do
      it "returns the application's notifier that belongs to this status" do
        @notifier = @status.application.notifiers.first
        @status.notifier.should eql(@notifier)
      end
    end
  end
end
