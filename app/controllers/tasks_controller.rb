class TasksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  class << self
    def task(cls)
      task_name = cls.name.underscore
      define_method task_name do
        logger.info "SCHEDULED JOB #{task_name} is called"
        cls.delay.execute
        render text: 'DONE!'
      end
    end
  end

  task BasicLessonExtension
  task CalculateMonthlyStatements
  task CalculateNextMonthlyStatements
  task NotifyMonthlyPaymentFixed
  task MonthlyCalculation
  task LessonCancellationCount
  task TutorLessonSkipClear
  task SkippedMeetings
  task SweepIgnoredLessonRequests
  task YuchoAccountPaymentsAndReceipts
  task ChargeEntryFee
  task ProcessMonthlyStatementUpdateRequests
end
