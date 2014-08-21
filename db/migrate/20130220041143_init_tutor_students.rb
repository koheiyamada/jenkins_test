class InitTutorStudents < ActiveRecord::Migration
  def up
    Tutor.all.each do |tutor|
      tutor.students = Student.joins(:lessons).where(lessons:{tutor_id:tutor.id}).uniq
    end
  end

  def down
  end
end
