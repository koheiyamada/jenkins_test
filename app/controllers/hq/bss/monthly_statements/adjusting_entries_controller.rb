class Hq::Bss::MonthlyStatements::AdjustingEntriesController < MonthlyStatements::AdjustingEntriesController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  before_filter :prepare_bs
  before_filter :prepare_monthly_statement
end
