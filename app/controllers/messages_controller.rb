class MessagesController < ApplicationController
  layout 'with_sidebar'
  before_filter :login_check

  def index
    session[:search] = params[:search] ? params[:search] : {}

    @message_controller =true
    @message_recipients =
      if params[:q]
        search_message_recipients
      else
        MessageRecipient.of_user(current_user).includes(:message).
        order('messages.created_at DESC').page(params[:page])
      end
  end

  def show
    @message = current_user.received_messages.find(params[:id])
    mrecipient = MessageRecipient.where(message_id: params[:id],
      recipient_id: current_user.id).first
    unless mrecipient.is_read
      mrecipient.update_attribute(:is_read, true)
      mrecipient.solr_index_for_message_recipient
    end
  end

  def reply
    @message = current_user.received_messages.find(params[:id])
    if @message.sender.present?
      redirect_to request.original_fullpath + '/../replies/new'
    else
      redirect_to action: :show
    end
  end

  def destroy
    @message = current_user.received_messages.find(params[:id])
    current_user.delete_message(@message)
    redirect_to action: :index
  end

  private
  def search_message_recipients(
    key =params[:q], options ={}, conditions = params[:search])
    default_opts = { page: (params[:page] || 1) }
    options = default_opts.merge options

    search = MessageRecipient.search do
      with :recipient_id, current_user.id
      options.each do |k, v|
        case k
        when :page then paginate page: v, per_page: (options[:per_page] || 25)
        end
      end

      if conditions['is_read'].present?
        with :is_read, conditions['is_read'] == 'false' ? false : true
      end

      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def login_check
    redirect_to root_path if current_user.blank?
  end
end