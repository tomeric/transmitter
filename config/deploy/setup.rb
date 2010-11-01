before "deploy:setup", "db:setup", "app:setup", "bundler:setup"

set :shared_directories, %w(config tmp tmp/pids tmp/sockets log)

namespace :setup do
  task :default do
    transaction do
      app.setup
      db.setup
      deploy.setup
    end
  end
  
  task :directories, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{home_dir}/shared"
  end
end

namespace :app do
  desc "Create shared directories and write application.yml in shared path"
  task :setup do
    directories
  end
  
  desc "Create shared directories"
  task :directories, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}"
  
    commands = shared_directories.map do |path|
      "mkdir -p #{shared_path}/#{path}"
    end
  
    run <<-CMD
      #{commands.join(" && ")}
    CMD
  end
end

namespace :db do
  desc "Create mongoid.yml in shared path"
  task :setup do
    db_config = ERB.new <<-YAML
    production: &defaults
      host: localhost
      user: #{user}
      password: #{password}
      database: #{user}_transmitter_production
    YAML

    put db_config.result, "#{shared_path}/config/mongoid.yml"
  end
end
