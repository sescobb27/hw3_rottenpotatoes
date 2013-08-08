source 'http://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem "linecache19", "0.5.12",path: "~/.rvm/gems/ruby-2.0.0-p247/gems/linecache19-0.5.12/"

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'sqlite3'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'simplecov'
  gem "ZenTest"
  gem "autotest-rails"
end
group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
end
group :production do
  #gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'              
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'haml'
