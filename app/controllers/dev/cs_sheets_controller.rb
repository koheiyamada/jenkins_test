class Dev::CsSheetsController < CsSheetsController
  before_filter :development_only

  def new
    @lesson = Lesson.only_done.last
    @cs_sheet = @lesson.cs_sheets.build
    @student = @lesson.students.first
  end
end
