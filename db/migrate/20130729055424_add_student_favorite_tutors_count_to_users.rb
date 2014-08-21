class AddStudentFavoriteTutorsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :student_favorite_tutors_count, :integer, :default => 0, :null => false

    Tutor.all.each do |tutor|
      Tutor.reset_counters tutor.id, :student_favorite_tutors
    end
    SpecialTutor.all.each do |tutor|
      Tutor.reset_counters tutor.id, :student_favorite_tutors
    end
  end
end
