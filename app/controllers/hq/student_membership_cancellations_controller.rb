class Hq::StudentMembershipCancellationsController < StudentMembershipCancellationsController
  include HqUserAccessControl
  hq_user_only
  access_control :student

  before_filter :attach_reason, :only => :create

  private

    def attach_reason
      params[:membership_cancellation] ||= {}
      params[:membership_cancellation][:reason] = t('membership_cancellation.by_hq_user_x', x: current_user.user_name)
    end
end
