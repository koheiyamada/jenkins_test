source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'devise'
gem 'haml-rails'
gem 'rails-i18n'
gem 'less-rails'
gem 'twitter-bootstrap-rails', '~> 2.2.6'
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'kaminari'
gem 'event-calendar', :require => 'event_calendar'
gem 'wicked'
gem 'carrierwave'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'rmagick', :require => false
gem 'whenever', :require => false
gem 'grizzled-rails-logger'
gem 'font-awesome-rails', '~> 3.2.0'
gem 'activemerchant'
gem 'progress_bar'
gem 'slim', '~> 1.3.8'
gem 'activerecord-import', '< 0.4'
gem 'detect_timezone_rails'
gem 'i18n-timezones'
gem 'cocoon'

# for payments by VeriTrans MDK
gem 'log4r', '>= 1.1.8'  # require 'openssl-devel' or similar package
gem 'libxml-ruby', '>= 1.1.3'  # require 'libxml2-devel' or similar package

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  #gem 'susy'
  gem 'compass'
  gem 'compass-rails'
  #gem 'compass-susy-plugin'
  gem 'jquery-ui-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'simplecov'
  gem 'spork-rails'
  gem 'sunspot_test'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'i18n_generators', :group => :development
  gem 'rails-erd'
  gem 'quiet_assets'
  gem 'thin'
  gem 'pry-rails'
  gem 'foreman'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

group :production do
  gem 'unicorn', '~> 4.3'
end

# Deploy with Capistrano
# gem 'capistrano'
gem 'capistrano', :require => nil
gem 'capistrano-ext', :require => nil
gem 'capistrano_colors', :require => nil

# To use debugger
# gem 'debugger'
