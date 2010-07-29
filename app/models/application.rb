class Application
  include Mongoid::Document
  
  ### ATTRIBUTES:
  
  field :name
  field :api_key
  field :url
  
  index :name
  index :api_key, :unique => true
  index :'notifiers.queue'
  
  referenced_in :status
  embeds_many :notifiers
  accepts_nested_attributes_for :notifiers
  
  ### VALIDATIONS:
  
  validates :name,    :presence => true
  validates :api_key, :uniqueness => true, :length => { :is => 40 }
  
  ### CALLBACKS:
  
  before_validation :generate_api_key, :unless => :api_key?
  
  ### CLASS METHODS:
  
  def self.notify(application_id, notification_id)
    application  = Application.find(application_id)
    notification = Notification.find(notification_id)
    
    notifiers = application.notifiers.find_all { |notifier| notifier.queue == notification.queue }
    
    notifiers.each do |notifier|
      notifier.deliver_later(notification)
    end
  end
  
  ### INSTANCE METHODS:
  
  def notify_later(notification)
    Navvy::Job.enqueue(Application, :notify, id, notification.id)
  end
  
  private
  
  def generate_api_key
    self.api_key = KeyGenerator.generate(40)
  end
  
end
