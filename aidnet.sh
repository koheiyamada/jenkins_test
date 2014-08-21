#!/bin/sh
bundle exec unicorn_rails -c /home/vagrant/workspace/AIDnetcpS/AIDnet20140807/aidnet/config/unicorn.rb -D -E development
