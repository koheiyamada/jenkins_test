# coding:utf-8
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :command, "cd :path && :task :output"

set :output, {:error => 'log/cron-error.log', :standard => 'log/cron.log'}
set :environment, ENV['RAILS_ENV']
set :server_port, environment == 'demo' ? 3020 : 3000
puts <<-END
################################################
#
# #{environment}
#
################################################
END

#every "44 * * * *" do
#  command "say hello"
#end

def add_task(task_name)
  unless File.exist? "app/scheduled_jobs/#{task_name}.rb"
    raise "Task #{task_name} does not exist!"
  end
  url = "http://localhost:#{server_port}/tasks/#{task_name}"
  command "/usr/bin/curl #{url} -X POST"
end

# 毎月21日3時にベーシックレッスンの延長処理を実行する
# ４ヶ月先までレッスンデータを作成するとともに、
# 今月の支払にカウントするレッスンデータに支払確定フラグを立てる。
# **この処理はcalculate_monthly_statementsよりも先に実行する必要がある**
every '0 3 21 * *', :roles => [:cron] do
  add_task :basic_lesson_extension
end

# 毎月21日3時30分に月次集計を実行する
every '30 3 21 * *', :roles => [:cron] do
  add_task :calculate_monthly_statements
end

# 毎月21日0時00分に翌月度分の月次集計を実行する（画面に出すデータを作るため）
every '0 0 21 * *', :roles => [:cron] do
  add_task :calculate_next_monthly_statements
end

# 毎月27日7時に集計完了通知メールを保護者と受講者に送信する。
every '30 7 27 * *', :roles => [:cron] do
  add_task :notify_monthly_payment_fixed
end

# 毎月27日3時10分に料金を（再）集計して全生徒の料金を実際に課金する
every '10 3 27 * *', :roles => [:cron] do
  add_task :monthly_calculation
end

# 毎日2時15分に前日のレッスンキャンセルを集計する
every 1.day, :at => '2:15am', :roles => [:cron] do
  add_task :lesson_cancellation_count
end

#
every '0 2 1 4,8,12 *', :roles => [:cron] do
  add_task :tutor_lesson_skip_clear
end

# 毎日2時30分に前日の面談のすっぽかしを集計して保護者にメールを送る。
# メールを送るのは朝8時ぐらい？
every 1.day, :at => '2:30am', :roles => [:cron] do
  add_task :skipped_meetings
end

# 毎時6分、21分、36分、51分に、無視されたレッスン申込をチェックする
every '6,21,36,51 * * * *', :roles => [:cron] do
  add_task :sweep_ignored_lesson_requests
end

# 更新が必要な月次集計処理を1時間ごとに実行する
every '2 * * * *', :roles => [:cron] do
  add_task :process_monthly_statement_update_requests
end

# ゆうちょ支払・請求一覧ファイルを更新する
every 1.day, :at => '2:45am', :roles => [:cron] do
  add_task :yucho_account_payments_and_receipts
end

# 入会金課金対象者に課金する
every 1.day, :at => '2:55am', :roles => [:cron] do
  add_task :charge_entry_fee
end

# チューターの長期非ログインをチェックする
#every 1.day, :at => '4:10am', :roles => [:cron] do
#  runner 'MonitorInactiveTutors.execute'
#end
