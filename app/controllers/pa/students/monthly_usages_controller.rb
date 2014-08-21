class Pa::Students::MonthlyUsagesController < MonthlyUsagesController
  parent_only
  before_filter :prepare_student

  private

    def subject
      @student
    end
end
