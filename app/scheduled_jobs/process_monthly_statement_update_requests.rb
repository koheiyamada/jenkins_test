class ProcessMonthlyStatementUpdateRequests < ScheduledJob

  def self.perform
    MonthlyStatementUpdateRequest.execute_all
  end

end