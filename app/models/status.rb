class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Workflow

  ### ATTRIBUTES:
  
  field :notifier_id
  field :state
  field :exception
  
  embedded_in :notification, :inverse_of => :statuses
  references_one :application
  
  ### VALIDATIONS:
  
  validates :notifier_id,  :presence => true
  validates :application,  :presence => true

  ### STATES:

  workflow do
    state :queued do
      event :start, :transitions_to => :in_progress
    end
    
    state :in_progress do
      event :fail,  :transitions_to => :failed
      event :close, :transitions_to => :processed
    end
    
    state :failed do
      event :start, :transitions_to => :in_progress
    end
    
    state :processed
  end
  
  def load_workflow_state
    state
  end

  def persist_workflow_state(new_value)
    self.state = new_value
    notification.save!
  end
  
  ### INSTANCE METHODS:
  
  def notifier
    @notifier ||= application.notifiers.detect { |n| n.id.to_s == notifier_id }
  end
  
end
