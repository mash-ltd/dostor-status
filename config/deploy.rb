ssh_options[:forward_agent] = true

set :stages, %w(production)
set :default_stage, "production"

require 'capistrano/ext/multistage'
require 'capistrano_colors'

capistrano_color_matchers = [
  { :match => /executing locally/,      :color => :green,     :prio => 10, :attribute => :underscore },
  { :match => /note/,                   :color => :blue,      :prio => 10, :attribute => :blink }
]

colorize( capistrano_color_matchers )


set :application,    'Dostor Status'

set :repository,     'git@github.com:mash-ltd/dostor-status.git'
set :scm,            'git'
set :deploy_via,     :remote_cache

set :bundle_flags,   '--binstubs --deployment'
set :bundle_without, [:development, :test, :cucumber, :darwin]

set :normalize_asset_timestamps, false
set :maintenance_template_path, File.join(File.dirname(__FILE__), '..', 'public', '503.html')

set :keep_releases, 5

# CALLBACKS

# RELEASE
after 'deploy:update', 'deploy:migrate'
after 'deploy:update', 'dostor:restart'
after 'deploy:setup',  'dostor:conf:create'

before 'deploy:setup', 'rvm:create_gemset'
before 'deploy:create_symlink', 'dostor:conf:update_symlinks'

set :shared_children, shared_children << 'tmp/sockets'
set :shared_children, shared_children << 'public/uploads'

set :shared_assets, %w{.rvmrc config/database.yml}
set :rvm_type, :root
set :rvm_ruby_string, '1.9.3-p374@dostor'

require "rvm/capistrano"

# TASKS
 
namespace :dostor do
  namespace :conf do
    desc "Creates the required configuration files"
    task :create, :roles => [:app, :web] do
      # rvmrc
      run "echo 'rvm use #{rvm_ruby_string}' > #{shared_path}/.rvmrc"
      # config files
      run "mkdir #{shared_path}/config"
      %w{database.yml}.each do |conf|
        template_location = fetch(:config_dir, "config/") + conf + "-example"
        template = File.read(template_location)

        put template, "#{shared_path}/config/#{conf}"
      end
    end

    desc "Updates the symlinks for shared assets"
    task :update_symlinks, :roles => :app do
      shared_assets.each { |link| run "ln -nfs #{shared_path}/#{link} #{release_path}/#{link}" }
    end
  end

  desc "Start the application"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec puma -e #{stage} -b 'unix://#{shared_path}/sockets/puma.sock' -S #{shared_path}/sockets/puma.state --control 'unix://#{shared_path}/sockets/pumactl.sock' > #{shared_path}/log/puma-#{stage}.log 2>&1 &", :pty => false
  end
 
  desc "Stop the application"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stop"
  end
 
  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state restart"
  end
 
  desc "Status of the application"
  task :status, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stats"
  end
end
