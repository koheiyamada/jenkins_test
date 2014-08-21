class Hq::Students::MonthlyStatements::AdjustingEntriesController < MonthlyStatements::AdjustingEntriesController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  before_filter :only_writable_user
  before_filter :prepare_student
  before_filter :prepare_monthly_statement
end
