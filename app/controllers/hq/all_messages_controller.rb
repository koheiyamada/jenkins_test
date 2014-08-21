class Hq::AllMessagesController < MessagesController
  hq_user_only

  def index
    @messages = Message.order('created_at DESC').page(params[:page])

    @messages.each do |message|
      message.title = message.title.slice(0..10)+"..." if message.title.length > 10
    end
  end

  def show
    @message = Message.find(params[:id])
  end
end
