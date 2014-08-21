class Pa::StudentsController < StudentsController
  include ParentAccessControl
  parent_only

  #def index
  #  if params[:q]
  #    @students = subject.search_students(params[:q], active:true)
  #  else
  #    @students = subject.students.page(params[:page])
  #  end
  #end

  def new
    @student = Student.new do |student|
      student.user_name = Student.generate_user_name
      student.birthday = 10.years.ago
      student.phone_number = current_user.phone_number
      if current_user.address
        student.address = current_user.address.dup
      else
        student.build_address
      end
      student.os = OperatingSystem.default
      student.student_info = StudentInfo.new
      student.parent = current_user
      student.build_user_operating_system
    end
  end

  def create
    parent_service = ParentService.new(current_user)
    @student = parent_service.create_student(params)
    if @student.errors.empty?
      redirect_to edit_pa_student_charge_path(@student)
    else
      render :new
    end
  end

  def home
    @student = current_user.students.find(params[:id])
    @messages = @student.received_messages.limit(5)
  end

  def show
    @student = current_user.students.find(params[:id])
  end

  def edit
    @student = subject.students.find(params[:id])
    @student_form = ParentStudentUpdateForm.new(@student)
  end

  def update
    @student = subject.students.find(params[:id])
    @student_form = ParentStudentUpdateForm.new(@student)
    if @student_form.update(params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  #def update
  #  @student = current_user.students.find(params[:id])
  #  @student.update_attributes!(params[:student])
  #  @student.student_info.update_attributes!(params[:student_info])
  #  redirect_to({action:"edit"}, notice:t("messages.updated"))
  #rescue => e
  #  logger.warn(e)
  #  render action:"edit"
  #end

  def change_password
    @student = current_user.students.find(params[:id])
    if request.put?
      if @student.update_attributes(params[:student])
        redirect_to({action:'show', id:@student}, notice:t('messages.password_updated'))
      end
    end
  end

  def mail_certification
    check_if_free_mode_off_and_free_parent
    @email_confirmation_form = nil
  end

  def send_email_to_student_from_parent
    target_email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
    temp_user = UserRegistrationForm.new 
    temp_user.email = target_email
    temp_user.type = "StudentRegistrationForm"
    temp_user.parent_id = current_user.id
    temp_user.save
    token = temp_user.confirmation_token
    ParentMailer.email_confirmation_by_parent(target_email,token).deliver
    redirect_to pa_students_path
  end

  private

  #保護者が無料体験会員、かつシステム無料体験モードがOFFになっていた場合支払い方法確認画面へリダイレクト
  def check_if_free_mode_off_and_free_parent
    if current_user.free? && SystemSettings.free_mode == false
      redirect_to confirmation_pa_payments_path
    end
  end
end