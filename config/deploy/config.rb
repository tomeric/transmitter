namespace :config do
  task :prepare do
    # do not use sudo
    set :use_sudo, false
    set :group_writable, false

    # we only have 1 server for app, web and db
    server machine, :app, :web, :db, :primary => true

    # scm
    set :repository, "git://github.com/tomeric/transmitter.git.git"
    set :scm, :git

    # we deploy to home directories
    set :deploy_to,  home_dir
    set :deploy_via, :remote_cache

    set :current_path, "#{home_dir}/current"
    set :release_name, Time.now.utc.strftime("%Y%m%d%H%M%S")
    set :current_revision, `git ls-remote #{repository} #{branch}`.split(/\s+/).first
  end
end
