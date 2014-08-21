class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.references :creator
      t.references :user1
      t.references :user2
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :finished_at
      t.text :note

      t.timestamps
    end
    add_index :interviews, :creator_id
    add_index :interviews, :user1_id
    add_index :interviews, :user2_id
  end
end
