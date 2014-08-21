class CreateWeekdaySchedules < ActiveRecord::Migration
  def change
    create_table :weekday_schedules do |t|
      t.references :tutor
      t.integer :wday
      t.time :from
      t.time :to
    end
    add_index :weekday_schedules, :tutor_id
  end
end
