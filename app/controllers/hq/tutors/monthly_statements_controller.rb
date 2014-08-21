class Hq::Tutors::MonthlyStatementsController < Hq::MonthlyStatementsController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  before_filter :prepare_tutor

  private

  def subject
    @tutor
  end
end
