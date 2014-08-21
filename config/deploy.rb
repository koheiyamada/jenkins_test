# coding:utf-8

require 'bundler/capistrano'

set :stages, %w(production staging demo)
set :default_stage, "demo"
require 'capistrano/ext/multistage'

set :application, "aid"
#set :repository,  "git://www.local.soba-project.com/git/aid.git"
set :repository,  "."
set :local_repository, "."
#set :branch, "master"
set :deploy_via, :copy
set :unicorn_port, 3000

set :scm, :git

set :user, 'app'
set(:deploy_to) { "/home/#{user}/apps/#{application}" }
set :use_sudo, false
set :keep_releases, 5

# cron
#set :whenever_environment, defer { stage }
set :whenever_command, "bundle exec whenever"
set :whenever_roles, [:cron]
require "whenever/capistrano"

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

#
# rbenv configuration
#
set :default_environment, {
  'RBENV_ROOT' => '$HOME/.rbenv',
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

namespace :deploy do
  desc "Start unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do
    find_servers_for_task(current_task).each do |server|
      run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D -l0.0.0.0:#{unicorn_port}", :hosts => server.host
      run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job start", :hosts => server.host
    end
  end

  desc "Stop unicorn"
  task :stop, :roles => :app, :except => {:no_release => true} do
    find_servers_for_task(current_task).each do |server|
      run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job stop", :hosts => server.host
      run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`", :hosts => server.host
    end
  end

  desc "Restart unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do
    find_servers_for_task(current_task).each do |server|
      run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`", :hosts => server.host
      #run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid.oldbin`"
      run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job stop", :hosts => server.host
      run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job start", :hosts => server.host
    end
  end

  desc "Restart unicorn including the master process"
  task :restart2, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  desc 'Restart only unicorn processes'
  task :restart_unicorn, :roles => :app do
    run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`"
    run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D -l0.0.0.0:#{unicorn_port}"
  end

  desc 'Restart only unicorn processes'
  task :restart_unicorn2, :roles => :app do
    run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
  end

  desc "Restart delayed_job"
  task :restart_delayed_job, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job stop"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job start"
  end

  desc "Start Solr"
  task :start_solr do
    find_servers_for_task(current_task).each do |server|
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start", :hosts => server.host
    end
  end

  desc "Make the symlink to public/uploads directory"
  task :symlink_uploads do
    run "mkdir -p #{shared_path}/uploads"
    run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
  end

  desc "Make the symlink to public/yucho_accounts"
  task :symlink_yucho_accounts do
    run "mkdir -p #{shared_path}/yucho_accounts"
    run "ln -nfs #{shared_path}/yucho_accounts  #{release_path}/public/yucho_accounts"
  end

  desc "Reindex solr"
  task :reindex, :roles => :db do
    find_servers_for_task(current_task).each do |server|
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:reindex", :hosts => server.host
    end
  end

  task :seeds_grades, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rails runner db/seeds/grades.rb"
  end

  task :setup_answer_books, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rails runner script/textbooks/populate_answer_books.rb"
  end

  task :update_charge_settings, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rails runner db/seeds/charge_settings.rb"
  end

  namespace :web do
    desc 'Present a maintenance page to visitors.'
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read('./app/views/layouts/maintenance.html.erb')
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

end

after 'deploy:update_code', 'deploy:symlink_uploads'
after 'deploy:update_code', 'deploy:symlink_yucho_accounts'
