class Hq::Tutors::MonthlyStatements::AdjustingEntriesController < MonthlyStatements::AdjustingEntriesController
  hq_user_only
  before_filter :prepare_tutor
  before_filter :prepare_monthly_statement
end
