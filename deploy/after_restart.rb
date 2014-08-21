#EngineYardへデプロイする時にこれらのコマンドが実行されます
run "ln -s /data/aid_tutoring_system2/shared/uploads/ /data/aid_tutoring_system2/current/public/uploads"
run "ln -s /data/aid_tutoring_system2/shared/yucho_accounts/ /data/aid_tutoring_system2/current/public/yucho_accounts"
run "cd /data/aid_tutoring_system2/current/"
run "bundle exec rake sunspot:solr:stop"
run "bundle exec rake sunspot:solr:start"
run "bundle exec rake sunspot:solr:reindex"
run "RAILS_ENV=production script/delayed_job stop"
run "RAILS_ENV=production script/delayed_job start"