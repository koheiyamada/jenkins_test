class AddRecordsToAnswerOption < ActiveRecord::Migration
  def change
  	date = Time.now.getutc.to_s
    date.slice!(" UTC")
    ActiveRecord::Base.connection.execute("delete from answer_options where code = 'other'")
    ActiveRecord::Base.connection.execute("insert into answer_options (question_id,code,created_at,updated_at) values (2,'free_lesson','#{date}','#{date}')")
    ActiveRecord::Base.connection.execute("insert into answer_options (question_id,code,created_at,updated_at) values (2,'free_user','#{date}','#{date}')")
    ActiveRecord::Base.connection.execute("insert into answer_options (question_id,code,created_at,updated_at) values (2,'other','#{date}','#{date}')")
  end
end
