module MembershipCancellationsHelper
  def membership_cancellation_status(membership_cancellation)
    t("membership_cancellation.statuses.#{membership_cancellation.status}")
  end
end