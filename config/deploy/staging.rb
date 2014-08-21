# All servers are in AWS VPC
# connect to server(s) must be use the VPN connection.
server = "test-system2.aidnet.jp"
set :rails_env, 'staging'
set :user, 'aid'
ssh_options[:keys] = '/home/vagrant/.ssh/aid.pem'

role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, :primary => true # This is where Rails migrations will run
role :cron, server
