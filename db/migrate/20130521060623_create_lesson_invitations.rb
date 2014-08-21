class CreateLessonInvitations < ActiveRecord::Migration
  def change
    create_table :lesson_invitations do |t|
      t.references :lesson
      t.references :student
      t.string :status, :default => 'new'

      t.timestamps
    end
    add_index :lesson_invitations, :lesson_id
    add_index :lesson_invitations, :student_id
  end
end
