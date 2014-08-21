class Pa::StudentMessagesController < MessagesController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'

  def index
    @student = current_user.students.find(params[:student_id])
    @messages = @student.received_messages.order("created_at DESC").page(params[:page])
  end

  def new
    @student = current_user.students.find(params[:student_id])
    @message = Message.new
    @recipients = current_user.contact_list
  end

  def create
    msg = params[:message].merge(recipients:User.where(id:params[:recipients]))
    @message = current_user.send_message(msg)
    if @message.persisted?
      redirect_to action:"index"
    else
      @recipients = current_user.contact_list
      render action:"new"
    end
  end

  def show
    @student = current_user.students.find(params[:student_id])
    @message = @student.received_messages.find(params[:id])
  end

  def destroy
    @student = current_user.students.find(params[:student_id])
    @message = @student.received_messages.find(params[:id])
    @student.delete_message(@message)
    redirect_to action:"index"
  end
end
