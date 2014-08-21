class MyMessageFilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    @message = current_user.sent_messages.find(params[:my_message_id])
  end

  def create
    files = params[:user_files]
    if files.present?
      logger.info "#{files.size} files uploaded"
      files.each do |file|
        @message.user_files.create(file: file)
      end
    end
    render json: {success: 1}
  end

  def show
    @user_file = @message.user_files.find(params[:id])
    send_file @user_file.file.path, disposition: 'attachment'
  end
end
