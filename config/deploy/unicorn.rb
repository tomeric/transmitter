namespace :deploy do
  desc "Start app server"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path}; script/unicorn start"
  end
  
  desc "Stop app server"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path}; script/unicorn stop"
  end

  desc "Soft restart app server"
  task :reload, :except => { :no_release => true } do
    run "cd #{current_path}; script/unicorn reload"
  end
  
  desc "Restart app server"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path}; script/unicorn restart"
  end
end
