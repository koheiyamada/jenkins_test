class Dev::LessonReportsController < LessonReportsController
  before_filter :development_only

  def new
    @lesson = Lesson.only_done.last
    @student = @lesson.students.first

    @lesson_report = LessonReport.new do |report|
      report.author = @tutor
      report.tutor = @lesson.tutor
      report.student = @student
      report.subject = @lesson.subject
      report.lesson_type = @lesson.basic? ? 'BasicLesson' : 'OptionalLesson'
      report.start_at = @lesson.start_time
      report.end_at = @lesson.end_time
    end
  end
end
