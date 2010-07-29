class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ### ATTRIBUTES:
  
  field :queue
  field :message
  
  embeds_many :statuses
  
  ### VALIDATIONS:
  
  validates :queue, :presence => true

  ### CALLBACKS:
  
  after_create :notify_applications_later
  
  def self.notify_applications(notification_id)
    notification = find(notification_id)

    Application.where('notifiers.queue' => notification.queue).each do |application|
      application.notify_later(notification)
    end
  end  
  
  private
  
  def notify_applications_later
    Navvy::Job.enqueue(Notification, :notify_applications, id)
  end
  
end
