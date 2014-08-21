class Hq::Students::MonthlyUsagesController < MonthlyUsagesController
  hq_user_only
  before_filter :prepare_student

  private

  def subject
    @student
  end
end
