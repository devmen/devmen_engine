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

  gem 'twitter-bootstrap-rails', '~> 2.0.8'
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
# using haml-rails, because haml gem dosn't give gemerators for rails 3
gem 'haml-rails', '~> 0.3.4'
gem 'simple_form', '~> 2.0.2'

gem 'capistrano-unicorn', '~> 0.1.5'
gem "capistrano", "~> 2.9.0", :require => false
gem "capistrano-ext"
gem "capistrano_colors", "~> 0.5.5", :require => false

gem 'rvm', '~> 1.11.3'
gem 'rvm-capistrano', '~> 1.2.2'

gem 'cancan', '~> 1.6.7'
gem 'inherited_resources', '~> 1.3.1'
gem 'authlogic', '~> 3.1.0'

gem 'russian', '~> 0.6.0'

gem 'markitup-rails', '~> 0.2.1'

group :development, :test do
  gem 'rspec-rails', '~> 2.10.1'
  gem 'capybara', '~> 1.1.2'
  gem "capybara-webkit", "~> 0.12.1" # need install libqt4-dev
  gem 'launchy', '~> 2.1.0'
  ## If it is a problem with execjs runtimes after rspec:install,
  ## use node.js or uncomment next lines
  #gem 'execjs'
  #gem 'therubyracer'

  case RbConfig::CONFIG['host_os']
    when /darwin/i
      gem 'rb-fsevent'
      gem 'growl'
    when /linux/i
      gem 'libnotify', "~> 0.7.2"
      gem 'rb-inotify', "~> 0.8.8"
    when /mswin|windows/i
      gem 'rb-fchange'
      gem 'win32console'
      gem 'rb-notifu'
  end

  gem "guard", "~> 1.0.3"
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.1.0"
  gem 'guard-rspec', '~> 0.7.3'
  gem 'guard-livereload', '~> 0.4.2'  

  gem 'database_cleaner'  
  gem 'factory_girl_rails', '~> 3.3.0', :require => false

  # It's a problem with rails3-generators and factory_girl_rails.
  # Fixture generator for factory_girl moved from rails3-generator, but rails3-generator 0.17.4 gem
  # have factory_girl generator yet (https://github.com/thoughtbot/factory_girl_rails/issues/53)
  # Use a temporary solution by "https://github.com/neocoin/rails3-generators.git".
  gem 'rails3-generators', :git => 'https://github.com/neocoin/rails3-generators.git'

  #for debuging
  gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
  gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
  gem 'ruby-debug19'
  gem 'faker'
  gem 'hirb'
end