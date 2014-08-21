class Hq::Students::MonthlyStatementsController < Hq::MonthlyStatementsController
  before_filter :prepare_student
  access_control :accounting

  private

    def subject
      @student
    end
end
