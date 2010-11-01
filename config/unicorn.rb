rails_env = ENV['RAILS_ENV'] || 'production'
APP_PATH  = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# 16 workers and 1 master
worker_processes rails_env == 'production' ? 16 : 4

# Load rails+transmitter into master before forking workers
# for super fast worker spawn times:
preload_app true

# Restart workers that have timed out
timeout 30

# Listen on a unix socket
listen File.join(APP_PATH, 'tmp', 'sockets', 'unicorn.sock'), :backlog => 2048

# Logging:
unicorn_logger = Logger.new(File.join(APP_PATH, 'log', 'unicorn.log'))
unicorn_logger.formatter = Logger::Formatter.new
logger unicorn_logger

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
 
  old_pid = File.join(APP_PATH, 'tmp', 'pids', 'unicorn.pid.oldbin')

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end  
end

after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection 
  Mongoid.database.connection.connect
end
