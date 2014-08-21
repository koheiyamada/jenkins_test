class MessageFilesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user_file = UserFile.find(params[:id])
    @message = Message.joins(:user_files).where(user_files: {id: @user_file.id}).first
    if @message
      if @message.can_read? current_user
        filename = make_filename(@user_file.file_identifier)
        send_file @user_file.file.path, disposition: 'attachment', filename: filename
      else
        render status: :not_found, text: t('common.file_not_found')
      end
    else
      render status: :not_found, text: t('common.file_not_found')
    end
  end

  private

  def make_filename(utf8_filename)
    if request_from_ie? && request.env['HTTP_ACCEPT_LANGUAGE'] =~ /^ja/
      URI.escape utf8_filename
    else
      utf8_filename
    end
  end

  def request_from_ie?
    request.env['HTTP_USER_AGENT'] =~ /MSIE \d/ ||
    request.env['HTTP_USER_AGENT'] =~ /Trident\/\d/
  end
end
