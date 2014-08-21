class Dev::LessonsController < LessonsController
  before_filter :development_only
  layout 'lesson_room'

  def room
    @lesson = SharedOptionalLesson.where(tutor_id: current_user.id).last
    @lesson.status = 'active'
    @tutor = @lesson.tutor
    @students = @lesson.students
  end
end
