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

set :bundle_flags,   '--deployment'
set :bundle_without, [:development, :test, :cucumber, :darwin]

set :normalize_asset_timestamps, false
set :maintenance_template_path, File.join(File.dirname(__FILE__), '..', 'public', '503.html')

set :keep_releases, 5

# CALLBACKS
# INITIAL SETUP
after 'deploy:setup', 'deploy:conf:create'

# RELEASE
after 'deploy:update', 'dostor_status:restart'

# TASKS

# Application specific
namespace :dostor_status do
  desc "Starts the application"
  task :start, :roles => [:web, :app] do
    run "touch #{current_release}/tmp/start.txt"
  end

  desc "Stops the application"
  task :stop, :roles => [:web, :app]  do
    run "touch #{current_release}/tmp/stop.txt"
  end

  desc "Restarts the application"
  task :restart, :roles => [:web, :app] do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
