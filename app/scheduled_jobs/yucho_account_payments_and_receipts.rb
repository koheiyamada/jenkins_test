class YuchoAccountPaymentsAndReceipts < ScheduledJob

  def self.perform
    today = Date.today
    year = today.year
    month = today.month
    YuchoAccountService.new.compile_billings_and_payments_files(year, month)
  end

end