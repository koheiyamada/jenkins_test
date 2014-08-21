class Hq::TutorMembershipCancellationsController < UserMembershipCancellationsController
  include HqUserAccessControl
  hq_user_only
  access_control :tutor

  prepend_before_filter do
    @user = Tutor.find(params[:tutor_id])
  end

  before_filter :insert_reason, only: :create

  private

    def insert_reason
      params[:membership_cancellation] ||= {}
      if params[:membership_cancellation][:reason].blank?
        params[:membership_cancellation][:reason] = t('membership_cancellation.by_hq_user_x', x: current_user.user_name)
      end
    end
end
