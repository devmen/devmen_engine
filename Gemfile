source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '~> 0.13.2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'haml', '~> 3.1.6'

group :development, :test do
  gem 'rspec-rails', '~> 2.10.1'
  gem 'capybara', '~> 1.1.2'
  # If it is a problem with execjs runtimes after rspec:install,
  # use node.js or uncomment next lines
  #gem 'execjs'
  #gem 'therubyracer'

  gem 'factory_girl_rails', '~> 3.3.0'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec', '~> 0.7.3'
  gem 'guard-livereload', '~> 0.4.2'
  gem 'libnotify', '~> 0.7.2'
end