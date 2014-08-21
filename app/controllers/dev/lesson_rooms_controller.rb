class Dev::LessonRoomsController < LessonsController
  before_filter :development_only
  layout 'lesson_room'

  def room
    @tutor = Tutor.only_active.first
    @students = Student.only_active.limit(2)
    @lesson = SharedOptionalLesson.new do |lesson|
      lesson.tutor = @tutor
      lesson.students = @students
      lesson.start_time = Time.current
      lesson.end_time = LessonSettings.duration_per_unit.minutes.since(lesson.start_time)
      lesson.units = 1
    end
  end

  def show

  end

end
