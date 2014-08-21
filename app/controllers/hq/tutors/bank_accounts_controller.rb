class Hq::Tutors::BankAccountsController < BankAccountsController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  prepend_before_filter :prepare_tutor

  private

    def subject
      @tutor
    end
end
