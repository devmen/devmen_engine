require 'capistrano_colors'
require "rvm/capistrano" # Rvm bootstrap
require 'bundler/capistrano'
require "whenever/capistrano"

server "5.9.201.157", :app, :web, :db, :primary => true

set :shared_host, "5.9.201.157"
set :application, "devmen_engine"
# set :unicorn_env, "staging"
set :deploy_to,   "/home/devmen/apps/devmen_engine/"

#default_run_options[:shell] = '/bin/bash'
default_run_options[:pty] = true

set :repository,  "git@github.com:devmen/devmen_engine.git"
set :scm, :git
set :rails_env, "production"
set :branch, "demo"
# set :deploy_via,  :remote_cache
set :deploy_via,  :copy
set :keep_releases, 5

set :user, "devmen"

set :use_sudo, false

set :rvm_ruby_string, "1.9.3@devmen_engine"
set :rvm_type, :user
set :normalize_asset_timestamps, false


after  "deploy",                 "deploy:cleanup"
after  "deploy:finalize_update", "deploy:config", "deploy:update_uploads"
after  "deploy:create_symlink",  "deploy:migrate"

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "staging")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end

CONFIG_FILES = %w(database)
namespace :deploy do
  task :setup_config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/system"
    run "mkdir -p #{shared_path}/uploads"
    CONFIG_FILES.each do |file|
      put File.read("config/#{file}.yml.example"), "#{shared_path}/config/#{file}.yml"
    end
    puts "Now edit the config files in #{shared_path}"
  end
  after "deploy:setup", "deploy:setup_config"

  before "deploy:cold", "deploy:install_bundler"
  task :install_bundler, :roles => :app do
    run "type -P bundle &>/dev/null || { gem install bundler --no-ri --no-rdoc; }"
  end


  task :config do
    CONFIG_FILES.each do |file|
      run "cd #{release_path}/config && ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
    end
  end

  task :update_uploads, :roles => [:app] do
    run "ln -nfs #{deploy_to}#{shared_dir}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{deploy_to}#{shared_dir}/system #{release_path}/public/system"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "Tail production log files"
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    trap ("INT") { puts "\nInterrupded"; exit 0; }
    puts
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

set :whenever_command, "bundle exec whenever"
