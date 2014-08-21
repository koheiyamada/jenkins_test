class StudentsController < UsersController
  layout 'with_sidebar'

  def index
    if params[:search]
      session[:search] = params[:search]
    else
      session[:search] = nil
      @search_data = {"grade"=>nil,"customer_type"=>nil}
    end
    if session[:search]
      @search_data = session[:search]
    end
    if params[:q]
      @students = search_students
    else
      @students = subject.students.only_active.for_list.page(params[:page])
    end
    if current_user.type == "HqUser" || current_user.type == "SystemAdmin"
      @grades = Grade.new.all_grades_for_select_box
      @customer_type = User.new.customer_type_for_select_box
    end
  end

  def left
    if params[:q]
      page = params[:page] || 1
      @students = StudentSearch.new(current_user).search_left_students(params[:q], page: page)
    else
      @students = subject.students.left.page(params[:page])
    end
  end

  def show
    @student = subject.students.find(params[:id])
  end

  def edit
    @edit_flg = true
    @student = subject.students.find(params[:id])
    @student_form = StudentUpdateForm.new(@student)
  end

  def update
    @student = subject.students.find(params[:id])
    @student_form = StudentUpdateForm.new(@student)
    if @student_form.update(params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def leave
    @student = subject.students.find(params[:id])
    if request.post?
      if @student.leave(params[:reason]).persisted?
        redirect_to({action:"index"}, notice:t("messages.student_left"))
      end
    end
  end

  def come_back
    @student = subject.students.find(params[:id])
    @student.revive!
    redirect_to({action:"show"}, notice:t("messages.user_revived"))
  end

  def destroy
    @student = subject.students.find(params[:id])
    @student.destroy
    redirect_to({action: 'index'}, notice: t('messages.user_deleted'))
  end

  private

  def subject
    current_user
  end

  def search_students
    page = params[:page] || 1
    options = {active: true, page: page, exclude_trial: true}
    conditions = params[:search]
    if current_user.type == "HqUser" || current_user.type == "SystemAdmin"
      subject.search_students(params[:q], options, conditions)
    else
      subject.search_students(params[:q], options)
    end
  end
end
