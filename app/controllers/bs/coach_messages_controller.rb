class Bs::CoachMessagesController < UserMessagesController
  bs_user_only
  layout 'with_sidebar'

  before_filter :prepare_coach

  def index
    query = BsMessageQuery.new(current_user)
    @messages = query.coach_messages(@coach).page(params[:page])
  end

  def show
    query = BsMessageQuery.new(current_user)
    @message = query.coach_messages(@coach).find_by_id(params[:id])
    if @message.nil?
      redirect_to action: :index
    end
  end

  private
    def prepare_coach
      @coach = current_user.organization.coaches.find_by_id(params[:coach_id])
    end
end
