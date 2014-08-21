class TrialStudentsController < UsersController
  layout 'with_sidebar'

  def index
    if params[:q]
      page = params[:page] || 1
      @students = StudentSearch.new(current_user).search_trial_students(params[:q], page: page)
    else
      @students = subject.trial_students.only_active.for_list.page(params[:page])
    end
  end

  def new
    @student = TrialStudent.new_with_default_values
  end

  def create
    @student = TrialStudent.new(params[:trial_student])
    if @student.save
      redirect_to action: :show, id: @student
    else
      render action: :new
    end
  end

  def show
    @student = subject.trial_students.find(params[:id])
  end

  def edit
    @student = subject.trial_students.find(params[:id])
  end

  def update
    @student = subject.trial_students.find(params[:id])
    if @student.update_attributes(params[:trial_student])
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def destroy
    @student = subject.trial_students.find(params[:id])
    @student.destroy
    redirect_to({action: 'index'}, notice: t('messages.user_deleted'))
  end

  private

  def subject
    current_user
  end
end
