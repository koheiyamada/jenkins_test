class App::MyMessagesController < ApplicationController
  layout 'with_sidebar'

  def index
    @messages = current_user.sent_messages.page(params[:page])
  end

  def show
    @message = current_user.sent_messages.find(params[:id])
  end

  def new
    @message = Message.new
    if params[:recipients]
      @message.recipients = current_user.contact_list.where(id:params[:recipients])
    elsif params[:bs_id]
      bs_user = Bs.find(params[:bs_id]).representative
      @message.recipients = [bs_user] if bs_user
    end
  end

  def create
    msg = params[:message]
    recipients = User.where(id:params[:recipients]).to_a
    if params[:to_headquarter]
      hq_users = Headquarter.first.users
      recipients += hq_users.to_a
    end
    if params[:to_bs]
      if current_user.organization.is_a?(Bs)
        bs_users = current_user.organization.bs_users
        recipients += bs_users.to_a
      end
    end
    if params[:to_all_students]
      recipients += current_user.students
    end
    if params[:to_all_bss]
      if current_user.admin?
        recipients += current_user.bs_users
      end
    end
    @message = current_user.send_message(title:msg[:title], text:msg[:text], recipients:recipients)
    if @message.persisted?
      redirect_to({action:"index"}, notice:t("messages.message_sent"))
    else
      render action:"new"
    end
  end

  def destroy
    @message = current_user.sent_messages.find_by_id(params[:id])
    if @message
      @message.destroy #受け取った側も読めなくなる
    end
    redirect_to({action:"index"}, notice:t("messages.message_deleted"))
  end
end
