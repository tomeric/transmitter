# Multisite:
load 'config/deploy/multisite'

# Unicorn:
load 'config/deploy/unicorn'

# Deployment:
load 'config/deploy/config'
load 'config/deploy/symlinks'
load 'config/deploy/setup'
load 'config/deploy/bundler'

# Remote tasks:
load 'config/deploy/console'
load 'config/deploy/rvm'

# Hoptoad:
require File.expand_path('../../boot', __FILE__)
require 'hoptoad_notifier/capistrano'

namespace :deploy do
  after :default, :cleanup

  task :default do
    transaction do
      update
    end
  end

  task :update do
    transaction do
      update_code
      symlink
    end
  end

  desc "Setup a GitHub-style deployment"
  task :setup, :except => { :no_release => true } do
    run "rm -rf #{current_path}; git clone #{repository} #{current_path}"
    run "cd #{current_path}; git branch --track #{branch} origin/#{branch} || echo -e '\033[1;31mCould not track #{branch}. Maybe its already being tracked?\033[0m' && exit 0"
  end
  
  desc "Update the deployed code"
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git checkout -q #{branch} && git branch backup-#{release_name} && git fetch origin; git reset --hard origin/#{branch}"
  end
  
  task :cleanup, :except => { :no_release => true } do
    # keep last 5 branches
    run "cd #{current_path}; git branch | sed -e '/*/d' -e 's/ *\(.*\)/\1/' | grep '^backup-[0-9]\{14\}' | sort -r | tail -n +5 | xargs git branch -d"
  end
  
  namespace :rollback do
    desc "Rollback code to a previous release"
    task :code, :except => { :no_release => true } do
      pattern = 's/ *\(.*\)/\1/'
    end

    desc "Rollback to a previous release"
    task :default do
      code
      restart      
    end
  end
  
  task :symlink do
    symlinks.make
  end
end
