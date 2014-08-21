class Bs::AllStudentMessagesController < UserMessagesController
  bs_user_only
  layout 'with_sidebar'

  def index
    query = BsMessageQuery.new(current_user)
    @messages = query.messages_between_students_and_tutors.page(params[:page])
  end

  def show
    query = BsMessageQuery.new(current_user)
    @message = query.messages_between_students_and_tutors.find_by_id(params[:id])
    if @message.nil?
      redirect_to action: :index
    end
  end
end
