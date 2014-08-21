class ParentMembershipCancellationsController < UserMembershipCancellationsController
  prepend_before_filter do
    @user = Parent.find(params[:parent_id])
  end

  before_filter :attach_reason, :only => :create

  private
    def user
      @user
    end

    def attach_reason
      params[:membership_cancellation] ||= {}
      params[:membership_cancellation][:reason] = t('membership_cancellation.by_hq_user_x', x: current_user.user_name)
    end
end
