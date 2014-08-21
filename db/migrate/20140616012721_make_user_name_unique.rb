class MakeUserNameUnique < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.connection.execute("alter table users add unique (user_name)")
  end
end