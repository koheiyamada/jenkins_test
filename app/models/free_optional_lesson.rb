class FreeOptionalLesson < OptionalLesson
  def free?
  	true
  end

  def establish
  	update_attributes({established: true}, as: :admin)
  	student = self.students.first
  	student.free_lesson_taken += 1
  	student.save
  end
end