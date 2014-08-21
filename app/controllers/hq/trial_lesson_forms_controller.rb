class Hq::TrialLessonFormsController < OptionalLessonFormsController
  hq_user_only

  before_filter do
    @title = t('trial_lesson.titles.new')
  end

  private

  def lesson_id
    params[:trial_lesson_id]
  end

  def finish_wizard_path
    if @optional_lesson.students.count == 1
      student = @optional_lesson.students[0]
      hq_trial_student_lessons_path(student)
    else
      hq_trial_lessons_path
    end
  end
end
