namespace :deploy do
  desc "Start app server"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path}; passenger start -S tmp/passenger.socket -d -e #{rails_env}"
  end
  
  desc "Stop app server"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path}; passenger stop --pid-file tmp/pids/passenger.pid"
  end

  desc "Soft restart app server (Does not work yet)"
  task :reload, :except => { :no_release => true } do
    deploy.restart
  end
  
  desc "Restart app server"
  task :restart, :except => { :no_release => true } do
    deploy.stop rescue nil
    deploy.start
  end
end
