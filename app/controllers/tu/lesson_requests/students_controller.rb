class Tu::LessonRequests::StudentsController < Tu::StudentsController
  before_filter :prepare_lesson_request

  def show
    @student = @lesson.students.find(params[:id])
  end

  private

    def prepare_lesson_request
      @lesson = Lesson.find(params[:lesson_request_id])
    end
end
