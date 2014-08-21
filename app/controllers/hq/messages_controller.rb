class Hq::MessagesController < MessagesController
  include HqUserAccessControl
  hq_user_only
  access_control

  def all
    @messages = Message.order('created_at DESC').page(params[:page])
  end
end
