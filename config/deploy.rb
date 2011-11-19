set :application, "StokFridge"

ssh_options[:username] = 'root'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:mariusbutuc/StockMyFridge.git"  # Your clone URL
set :branch, "master"
set :scm, "git"
set :scm_verbose, true
set :user, "root"              # The server's user for deploys
set :scm_passphrase, "r3dhat^" # The deploy user's password
set :ssh_options, { :forward_agent => true }

role :web, "stokfridge.com"                   # Your HTTP server, Apache/etc
role :app, "stokfridge.com"                   # This may be the same as your `Web` server
role :db,  "stokfridge.com", :primary => true # This is where Rails migrations will run
set :deploy_to, "/var/www/stokfridge"

#after 'deploy:update_code', 'deploy:install_gems'
after 'deploy:update_code', 'deploy:create_symlinks'

namespace :deploy do
	[:start, :restart].each do |t|
		desc "#{t.to_s.capitalize} Application"
		task t do
			run "touch #{release_path}/tmp/restart.txt"
		end
	end
	
	desc 'Stop does not do anything with passenger'
	task :stop do
	end
	
	task :create_symlinks do
		run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db"
	end
	
	desc 'Install missing gems'
	task :install_gems do
		run "cd #{release_path} && bundle install"
	end
end
