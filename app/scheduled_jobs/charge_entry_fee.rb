class ChargeEntryFee < ScheduledJob

  def self.perform
    Student.to_pay_entry_fee.find_each do |student|
      student.create_entry_fee
    end
  end

end