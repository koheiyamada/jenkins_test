class Tu::LessonLessonReportsController < LessonReportsController
  tutor_only
  before_filter :prepare_lesson
  before_filter :prepare_student, :only => [:new, :create]

  def index
    @lesson_reports = @lesson.lesson_reports
  end

  def new
    if @lesson.report_of(@student).present?
      redirect_to tu_lesson_path(@lesson)
    elsif !current_user.should_write_lesson_report?(@lesson, @student)
      redirect_to tu_lesson_path(@lesson)
    else
      @lesson_report = LessonReport.new do |report|
        report.author = current_user
        report.tutor = @lesson.tutor
        report.student = @student
        report.subject = @lesson.subject
        report.lesson_type = @lesson.basic? ? 'BasicLesson' : 'OptionalLesson'
        report.start_at = @lesson.start_time
        report.end_at = @lesson.end_time
      end
    end
  end

  def create
    @lesson = current_user.lessons.find(params[:lesson_id])
    @lesson_report = LessonReport.new(params[:lesson_report]) do |lesson_report|
      lesson_report.author = current_user
      lesson_report.lesson = @lesson
      lesson_report.student = @student
    end
    if @lesson_report.save
      redirect_to tu_lesson_path(@lesson)
    else
      render action:"new"
    end
  end

  def show
    @lesson_report = @lesson.lesson_reports.find(params[:id])
  end

  private
    def prepare_lesson
      @lesson = Lesson.find(params[:lesson_id]) if params[:lesson_id].present?
    end

    def prepare_student
      @student = Student.find_by_id(params[:student_id])
    end
end
