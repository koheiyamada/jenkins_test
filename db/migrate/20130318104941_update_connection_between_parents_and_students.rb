class UpdateConnectionBetweenParentsAndStudents < ActiveRecord::Migration
  def up
    Dependent.all.each do |dependent|
      student = Student.find(dependent.student_id)
      student.parent_id = dependent.parent_id
      student.save!
    end
  end

  def down
  end
end
