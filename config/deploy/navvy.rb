namespace :navvy do
  after "deploy", "navvy:restart"

  desc "Start processing background jobs"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/navvy start"
  end
  
  desc "Stop processing background jobs"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/navvy stop"
  end
  
  desc "Restart processing background jobs"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/navvy restart"
  end
end
