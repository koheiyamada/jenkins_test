# encoding: utf-8
class MyMessagesController < ApplicationController
  layout 'with_sidebar'
  before_filter :load_recipients, only: :new

  def index
    session[:search] = params[:search] ? params[:search] : {}
    @message_controller = true

    @messages =
      if params[:q]
        key = params[:q]
        options = { page: (params[:page] || 1) }
        conditions = params[:search]

        Message.exec_search_by(current_user, key, options, conditions)
      else
        current_user.sent_messages.page(params[:page])
      end
  end

  def show
    @message = current_user.sent_messages.find(params[:id])
  end

  def new
    @message = Message.new
    if @recipients.present?
      @message.recipients = @recipients
    elsif params[:bs_id]
      bs_user = Bs.find(params[:bs_id]).representative
      @message.recipients = [bs_user] if bs_user
    end
  end

  def create
    sender = MessageSender.new(current_user, params[:recipients], params[:message])
    respond_to do |format|
      format.html do
        if sender.send
          redirect_to({action: :index}, notice: t('messages.message_sent'))
        else
          @message = sender.message
          render :new
        end
      end
      format.json do
        if sender.send
          @message = sender.message
          render json: {success: 1, id: @message.id}
        else
          @message = sender.message
          render json: {success: 0, error_messages: @message.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @message = current_user.sent_messages.find_by_id(params[:id])
    if @message
      @message.destroy #受け取った側も読めなくなる
    end
    redirect_to({action:"index"}, notice:t("messages.message_deleted"))
  end

  private

    # 投函前に呼ばれる
    def on_creating(message)
      # do nothing
    end

    def load_recipients
      if params[:recipients]
        @recipients = User.where(id: params[:recipients])
      end
    end

end
