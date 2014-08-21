module ReplyMessageHandler
  def self.included(base_controller)
    base_controller.before_filter :prepare_original_message
  end

  def new
    @message = Message.new
    @message.original_message = @original_message
    @message.title = @original_message.reply_title
    @message.text = "\n\n" + @original_message.citation_text
    @message.recipients = [@original_message.sender]
  end

  private

    def prepare_original_message
      @original_message = current_user.received_messages.find(params[:message_id])
    end
end