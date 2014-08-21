class TutorsController < UsersController
  layout 'with_sidebar'

  def index
    if params[:q]
      @tutors = subject.search_tutors(params[:q], active:true)
    else
      @tutors = subject.tutors.only_active.for_list.order("created_at DESC").page(params[:page])
    end
  end

  def left
    @tutors = subject.tutors.left.order("left_at DESC").page(params[:page])
  end

  def absent
    @tutors = subject.tutors.inactive_for_long.for_list.order(:last_request_at, :current_sign_in_at).page(params[:page])
  end

  def show
    @tutor = subject.tutors.find(params[:id])
    @subject_levels = @tutor.subject_levels.includes(:subject => :grade_group)
  end

  def teaching_subjects
    @tutor = subject.tutors.find(params[:id])
    @teaching_subjects = @tutor.teaching_subjects
  end

  def edit
    @tutor = subject.tutors.find(params[:id])
    @tutor_form = TutorUpdateForm.new(@tutor)
  end

  def update
    @tutor = subject.tutors.find(params[:id])
    @tutor_form = TutorUpdateForm.new(@tutor)
    if @tutor_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @tutor = subject.tutors.find(params[:id])
    @tutor.destroy
    redirect_to({action: 'index'}, notice: t('messages.user_deleted'))
  end

  private

  def subject
    current_user
  end

end
