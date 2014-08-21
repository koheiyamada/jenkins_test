class Bs::MessagesController < MessagesController
  bs_user_only

  def coaches
    @messages = current_user.organization.messages_to_coaches.page(params[:page])
  end

  def coach
    @message = current_user.organization.messages_to_coaches.find(params[:id])
  end
end
