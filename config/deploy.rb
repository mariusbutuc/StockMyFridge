set :application, "StokFridge"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:mariusbutuc/StockMyFridge.git"  # Your clone URL
set :branch, "master"
set :scm, "git"
#set :scm_verbose, true
set :user, "root"              # The server's user for deploys
set :scm_passphrase, "r3dhat^" # The deploy user's password

role :web, "stokfridge.com"                   # Your HTTP server, Apache/etc
role :app, "stokfridge.com"                   # This may be the same as your `Web` server
role :db,  "stokfridge.com", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/stokfridge"
