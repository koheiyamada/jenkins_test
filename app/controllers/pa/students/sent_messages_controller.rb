class Pa::Students::SentMessagesController < MyMessagesController
  before_filter :prepare_student

  def index
    @messages = @student.sent_messages.page(params[:page])
  end

  def show
    @message = @student.sent_messages.find(params[:id])
  end
end
