class Hq::Bss::MonthlyStatementsController < Hq::MonthlyStatementsController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  before_filter :prepare_bs

  private

    def subject
      @bs
    end
end
