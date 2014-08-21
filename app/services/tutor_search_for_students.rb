class TutorSearchForStudents < TutorSearchForOptionalLessons
  default_fields :nickname, :college, :department, :birth_place, :high_school, :hobby,
                 :activities, :teaching_experience, :teaching_results, :free_description,
                 :jyuku_history, :favorite_books

  attr_reader :student

  def initialize(student, params)
    super(params)
    @student = student
  end

  def set_lesson_fee_conditions(search_scope)
    if max_lesson_fee
      search_scope.with(lesson_fee_field).less_than max_lesson_fee
    end
    if min_lesson_fee
      search_scope.with(lesson_fee_field).greater_than min_lesson_fee
    end
  end

  private

    def lesson_fee_field
      @lesson_fee_field ||= "lesson_fee_#{grade_premium}".to_sym
    end

    def grade_premium
      @grade_premium ||= student.grade_premium || 0
    end
end
