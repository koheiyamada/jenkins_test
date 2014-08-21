class Hq::Students::LedgersController < LedgersController
  hq_user_only
  before_filter :prepare_student

  private

  def ledgerable
    @student
  end
end
