class Application
  include Mongoid::Document
  
  ### ATTRIBUTES:
  
  field :name
  field :api_key
  field :url
  
  index :name
  index :api_key, :unique => true
  index :'notifiers.queue'
  
  referenced_in :status, :class_name => 'Status'
  references_many :notifications
  
  embeds_many :notifiers
  accepts_nested_attributes_for :notifiers
  
  ### VALIDATIONS:
  
  validates :name,    :presence => true
  validates :api_key, :uniqueness => true, :length => { :is => 40 }
  
  ### CALLBACKS:
  
  before_validation :generate_api_key, :unless => :api_key?
  
  ### INSTANCE METHODS:
  
  def notify_later(notification)    
    notification_notifiers = notifiers.find_all { |notifier| notifier.queue == notification.queue }
    
    notification_notifiers.each do |notifier|
      notifier.deliver_later(notification)
    end
  end
  
  private
  
  def generate_api_key
    self.api_key = KeyGenerator.generate(40)
  end
  
end
