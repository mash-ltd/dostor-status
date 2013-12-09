set :deploy_to,         '/home/planoroid/public_html/dostor'
set :user,              'planoroid'
set :port,              1989
set :use_sudo,          false

set :branch,            "stable"

role  :web,             "198.61.232.122"
role  :app,             "198.61.232.122"
role  :db,              "198.61.232.122", primary: true

set :rails_env,         "production"
set :asset_env,         "RAILS_GROUPS=assets" # dont ever remove

before "deploy:create_symlink", "deploy:assets:precompile_and_sync"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

namespace :deploy do
  namespace :assets do
    desc "Precompiles the assets and uploads them to the CDN using asset_sync gem"
    task :precompile_and_sync do
      unless ENV['force']
        git_command = "git log #{previous_revision}..#{current_revision}"
        nchanges = capture("cd #{latest_release} && #{git_command} vendor/assets/ lib/assets/ app/assets/ Gemfile.lock| wc -l")
        if nchanges.to_i > 0
          capture %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
          capture %Q{rm -rf public/assets}
        else
          logger.info "note: skipping asset pre-compilation because there were no asset changes"
        end
      else
        capture %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        capture %Q{rm -rf public/assets}
      end
    end
  end
end
