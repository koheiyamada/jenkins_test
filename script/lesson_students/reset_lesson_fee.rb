ActiveRecord::Base.transaction do
  LessonStudent.all.each do |s|
    s.update_base_lesson_fee_per_unit
  end
end
