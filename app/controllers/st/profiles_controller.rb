class St::ProfilesController < ProfilesController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'
  before_filter :only_independent, :only => [:leave]
  after_filter :student_updated, :only => [:update]

  def show
    @student = current_user
  end

  def leave
    @student = current_user
    if request.post?
      @student.leave!(reason:params[:reason])
      sign_out @student
      redirect_to "/left"
    end
  end

  def edit
    @edit_flg = true
    @student = current_user
    if @student.address.blank?
      @student.build_address
    end
    @student_form = student_update_form(@student)
  end

  def update
    @student = current_user
    @student_form = student_update_form(@student)
    if @student_form.update(params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

 def change_email
    @student = current_user
    if request.post?
      temp_user = UserRegistrationForm.find(current_user.id)
      @student_form = UserRegistrationEmail.new
      @student_form.user_id = current_user.id
      @student_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @student_form.token = temp_user.confirmation_token
      @student_form.save
      StudentMailer.change_email_student(@student_form.email,@student_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @student = emailc.user
        @student.email = emailc.email
        @student.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

  private

    def student_update_form(student)
      if student.independent?
        StudentUpdateForm.new(student)
      else
        ParentStudentUpdateForm.new(student)
      end
    end

    def only_independent
      unless current_user.independent?
        redirect_to action:"show"
      end
    end

    def student_updated
      Mailer.send_mail(:student_updated, current_user)
    end
end
