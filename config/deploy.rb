set :application, "barrioearth.com"
set :repository,  "git@github.com:democritus/property-manager.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# This should be the default, so left commented
#set :deploy_to, "/u/apps/#{application}"

server "luna.qlogicinc.com", :app, :web, :db, :primary => true # alternative syntax to "role"
#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# What does this do? Need to figure out how to auto-create config/mongrel.yml from these parameters
set :mongrel_port, "8000"
set :mongrel_nodes, "2"

# Deploying with git seems to require: default_run_options[:pty] = true
# http://groups.google.com/group/capistrano/browse_thread/thread/13b029f75b61c09d
default_run_options[:pty] = true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
