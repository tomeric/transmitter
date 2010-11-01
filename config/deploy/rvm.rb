$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                               # Load RVM's capistrano plugin.

set :rvm_ruby_string, '1.9.2@transmitter'
set :rvm_type, :user
