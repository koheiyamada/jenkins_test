class CreateBasicLessonInfos < ActiveRecord::Migration
  def change
    create_table :basic_lesson_infos do |t|
      t.references :tutor
      t.references :subject
      t.text :wdays
      t.time :start_time
      t.time :end_time
      t.integer :units
      t.date :final_day

      t.timestamps
    end
    add_index :basic_lesson_infos, :tutor_id
    add_index :basic_lesson_infos, :subject_id
  end
end
