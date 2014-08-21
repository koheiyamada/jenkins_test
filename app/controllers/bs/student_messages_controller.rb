class Bs::StudentMessagesController < UserMessagesController
  bs_user_only
  layout 'with_sidebar'

  before_filter :prepare_student, :student_required

  def index
    query = BsMessageQuery.new(current_user)
    @messages = query.messages_between_student_and_tutors(@student).page(params[:page])
  end

  def show
    query = BsMessageQuery.new(current_user)
    @message = query.messages_between_student_and_tutors(@student).find_by_id(params[:id])
    if @message.nil?
      redirect_to action: :index
    end
  end

  private
    def prepare_student
      @student = current_user.students.find_by_id(params[:student_id])
    end

    def student_required
      if @student.nil?
        redirect_to action: :index
      end
    end
end
