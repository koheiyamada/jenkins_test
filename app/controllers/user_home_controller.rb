class UserHomeController < ApplicationController
  layout 'with_sidebar'

  def index
    @message_recipients = MessageRecipient.of_user(current_user).includes(:message).order('messages.created_at DESC').limit(10)
  end

end
