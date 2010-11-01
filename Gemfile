source "http://rubygems.org"

# Rails:
gem "rails",     "3.0.1"
gem "passenger"

# Database:
gem "mongoid",       ">= 2.0.0.beta.19"
gem "bson_ext"
gem "workflow"
gem "will_paginate", ">= 3.0.pre2"

# Frontend:
gem "haml"
gem "formtastic"

# Libraries:
gem "navvy"
gem "httparty"
gem "addressable", :require => "addressable/uri"

group :development do
  gem "capistrano"
end

group :production do
  gem "unicorn"
end

group :test do
  gem "factory_girl_rails"
  gem "rspec-rails"
  gem "database_cleaner"
  gem "ffaker"
  gem "remarkable_mongoid"
end
