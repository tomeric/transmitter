class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ### ATTRIBUTES:
  
  field :queue
  field :message
  
  embeds_many :statuses
  references_one :application
  
  ### VALIDATIONS:
  
  validates :queue, :presence => true

  ### SCOPES:
  
  scope :latest, order_by(:created_at.desc)

  ### CALLBACKS:
  
  after_create :notify_applications_later
  
  ### CLASS METHODS:
  
  def self.clean!
    Notification.not_in(:'statuses.state' => ['queued', 'in_progress', 'failed']).destroy_all
  end
  
  def self.notify_applications(notification_id)
    notification = find(notification_id)

    Application.where('notifiers.queue' => notification.queue).each do |application|
      application.notify_later(notification)
    end
  end  
  
  ### PRIVATE METHODS:
  
  private
  
  def notify_applications_later
    Navvy::Job.enqueue(Notification, :notify_applications, id)
  end
  
end
