# All servers are in AWS VPC
# connect to server(s) must be use the VPN connection.
primary_server = "54.86.201.212"
servers = [
  primary_server,
]

set :rails_env, 'production'
set :user, 'deploy'
ssh_options[:keys] = '/home/vagrant/.ssh/aid_ey.pem'

role :web, *servers                          # Your HTTP server, Apache/etc
role :app, *servers                          # This may be the same as your `Web` server
role :db,  primary_server, :primary => true # This is where Rails migrations will run
role :cron, primary_server
