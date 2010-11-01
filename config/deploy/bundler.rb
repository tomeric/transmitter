after "deploy:update", "bundler:new_release"

namespace :bundler do
  desc "Setup the bundler directory"
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/.bundle; gem install bundler"
  end
  
  desc "Install gems specified in Gemfile"
  task :new_release, :roles => :app do
    run "cd #{current_path}; bundle install"
  end
end
