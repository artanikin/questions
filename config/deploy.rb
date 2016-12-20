# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "questions"
set :repo_url, "git@github.com:arty88/questions.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/questions"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart
end
