class Bs::AllCoachMessagesController < UserMessagesController
  bs_user_only
  layout 'with_sidebar'

  def index
    query = BsMessageQuery.new(current_user)
    @messages = query.all_coach_messages.page(params[:page])
  end

  def show
    query = BsMessageQuery.new(current_user)
    @message = query.all_coach_messages.find_by_id(params[:id])
    if @message.nil?
      redirect_to action: :index
    end
  end
end
