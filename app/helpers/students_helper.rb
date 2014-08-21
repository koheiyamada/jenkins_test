module StudentsHelper
  def grade(obj)
    grade_name(obj)
  end

  def grade_name(obj)
    if obj.is_a?(Student)
      grade_name(obj.grade)
    elsif obj.is_a?(Grade)
      t("grades.#{obj.code}.name")
    elsif obj.is_a?(Integer)
      t('grade')[obj]
    else
      nil
    end
  end

  def student_registered_day(student)
    day = student.registered_day
    if day
      l day, format: :year_month_day
    end
  end
end