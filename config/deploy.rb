# require "bundler/capistrano"

set :application, "GeoQuest-Editor"
set :repository,  "git://github.com/geoquest/GeoQuest-Editor.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/geoquest/rails/#{application}"

set :user, 'geoquest'
set :scm_username, 'geoquest'

set :ssh_options, {:forward_agent => true}

set :use_sudo, false
# since sudo-ing might confuse access rights

role :web, "geoquest.qeevee.org"                          # Your HTTP server, Apache/etc
role :app, "geoquest.qeevee.org"                          # This may be the same as your `Web` server
role :db,  "geoquest.qeevee.org", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

#after "deploy", "deploy:bundle_gems"
#after "deploy:bundle_gems", "deploy:restart"

# If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
#  task :bundle_gems do
#    run "cd #{deploy_to}/current && bundle install vendor/gems"
#  end
task :start do
  run "#{deploy_to}/current/script/start.sh"
end
task :stop do
  run "#{deploy_to}/current/script/stop.sh"
end
task :restart, :roles => :app, :except => { :no_release => true } do
  run "touch #{File.join(current_path,'tmp','restart.txt')}"
end
#end

