class Notifier
  include Mongoid::Document
  
  HTTP_SUCCESS_CODES = (200..206).to_a + # HTTPSuccess
                       (300..307).to_a   # HTTPRedirection
  
  
  ### ATTRIBUTES:
  
  field :queue,   :index => true
  field :endpoint
  
  embedded_in :application, :inverse_of => :notifiers
  
  ### VALIDATIONS:
  
  validates :queue,    :presence => true
  validates :endpoint, :presence => true, :url => true

  ### CLASS METHODS
  
  def self.deliver(application_id, notifier_id, notification_id)
    application  = Application.find(application_id)
    notifier     = application.notifiers.find(notifier_id)
    notification = Notification.find(notification_id)
    status       = notification.statuses.where(:notifier_id => notifier.id.to_s).first
 
    status.start!
    
    begin
      response = HTTParty.post(notifier.endpoint, :queue   => notification.queue,
                                                  :message => notification.message)
    rescue => e
      response = e
    end
    
    if response && response.respond_to?(:code) && HTTP_SUCCESS_CODES.include?(response.code.to_i)
      status.close!
    else
      status.exception = response.inspect
      status.fail!
      raise "Failed to publish Notification: #{notification.id} to #{application.name}: #{notifier.endpoint}\nInspect:\n#{response.inspect})"
    end
  end

  ### INSTANCE METHODS:
  
  def deliver_later(notification)
    status = notification.statuses.create!(:application => application, :notifier_id => id.to_s)

    Navvy::Job.enqueue(Notifier, :deliver, application.id, id, notification.id)
  end

end
