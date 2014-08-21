class CreateTutorDailyAvailableTimes < ActiveRecord::Migration
  def change
    create_table :tutor_daily_available_times do |t|
      t.references :tutor, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end

    add_index :tutor_daily_available_times, :tutor_id
  end
end
