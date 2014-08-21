class CreateStudentFavoriteTutors < ActiveRecord::Migration
  def change
    create_table :student_favorite_tutors, id:false do |t|
      t.references :student
      t.references :tutor
    end
    add_index :student_favorite_tutors, :student_id
    add_index :student_favorite_tutors, :tutor_id
  end
end
