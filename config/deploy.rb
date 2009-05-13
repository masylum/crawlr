set :application, "crawlr"
set :user, "rails"
set :use_sudo, true

set :repository,  "git@github.com:masylum/crawlr.git"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :git_enable_submodules, 1         # Make sure git submodules are populated

set :port, 333                      # The port you've setup in the SSH setup section
set :location, "87.98.187.137"
role :app, location
role :web, location
role :db,  location, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Make symlink for database.yml" 
  task :symlink_dbyaml do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end

  desc "Create empty database.yml in shared path" 
  task :create_dbyaml do
    run "mkdir -p #{shared_path}/config" 
    put '', "#{shared_path}/config/database.yml" 
  end
end

after 'deploy:setup', 'deploy:create_dbyaml'
after 'deploy:update_code', 'deploy:symlink_dbyaml'

after "deploy", "deploy:cleanup"
