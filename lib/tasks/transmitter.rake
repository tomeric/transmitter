namespace :transmitter do
  desc "Clear out old notifications later"
  task :clean => :environment do
    puts "Queueing clean up of notifications"
    Navvy::Job.enqueue(Notification, :clean!)
  end
  
  desc "Clear out old notifications now"
  task :clean_now => :environment do
    Notification.clean!
  end
end
