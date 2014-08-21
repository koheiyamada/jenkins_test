#server = "ec2-176-34-9-79.ap-northeast-1.compute.amazonaws.com"
server = "49.212.136.180" # TEST sakura VPS
set :user, 'app'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :unicorn_port, 3020
set :rails_env, 'demo'

role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, :primary => true # This is where Rails migrations will run
role :cron, server
