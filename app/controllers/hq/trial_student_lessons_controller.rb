class Hq::TrialStudentLessonsController < LessonsController
  before_filter do
    @student = TrialStudent.find(params[:trial_student_id])
  end

  def new

  end

  def create
    current_user.clear_incomplete_lessons
    @trial_lesson = TrialLesson.new_for_form
    @trial_lesson.creator = current_user
    @trial_lesson.students << @student
    if @trial_lesson.save
      redirect_to hq_trial_lesson_forms_path(@trial_lesson, params)
    else
      render action:'new'
    end
  end

  private

  def subject
    @student
  end
end
