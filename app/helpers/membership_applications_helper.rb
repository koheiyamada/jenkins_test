module MembershipApplicationsHelper
  def membership_application_bank_account(membership_application)
    membership_application.user.bank_account.account
  rescue => e
    nil
  end

  def membership_application_status(membership_application)
    t("membership_application.statuses.#{membership_application.status}")
  end
end