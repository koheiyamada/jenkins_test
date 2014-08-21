class BasicLessonInfoStudentsController < StudentsController
  before_filter do
    # 同時レッスンへの追加用に、自分のところと関係のない受講者の分も閲覧できる必要がある。
    @basic_lesson_info = BasicLessonInfo.find(params[:basic_lesson_info_id])
  end

  # POST basic_lesson_infos/:basic_lesson_infos_id/students/add
  def new
    if params[:q]
      student_ids_to_exclude = @basic_lesson_info.student_ids
      @students = current_user.search_students(params[:q], active:true).select{|s| !student_ids_to_exclude.include?(s.id)}
    else
      ids = @basic_lesson_info.student_ids
      if ids.empty?
        @students = current_user.active_students.page(params[:page])
      else
        @students = current_user.active_students.where('id NOT IN (?)', ids).page(params[:page])
      end
    end
  end

  # POST basic_lesson_infos/:basic_lesson_infos_id/students
  def create
    @student = Student.find_by_id(params[:student_id])
    if @student
      @basic_lesson_student = @basic_lesson_info.add_student(@student)
      if @basic_lesson_student.persisted?
        redirect_to redirect_path, notice: t('lesson.message.student_added')
      else
        render :new
      end
    else
      redirect_to action: 'index'
    end
  end

end
