class Hq::MembershipCancellationsController < MembershipCancellationsController
  include HqUserAccessControl
  hq_user_only

  def index
    @membership_cancellations = MembershipCancellation.order('created_at DESC').page(params[:page])
  end

  def show
    @membership_cancellation = MembershipCancellation.find(params[:id])
  end

  def destroy
    @membership_cancellation = MembershipCancellation.find(params[:id])
    @membership_cancellation.destroy
    redirect_to action: :index
  end
end
