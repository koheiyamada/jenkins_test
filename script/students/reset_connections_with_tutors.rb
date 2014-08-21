ActiveRecord::Base.transaction do
  Student.all.each do |student|
    tutors = student.lessons.map(&:tutor).compact.uniq
    student.lesson_tutors = tutors
  end
end