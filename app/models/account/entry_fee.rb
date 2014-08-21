class Account::EntryFee < Account::JournalEntry
  validates_uniqueness_of :owner_id, :scope => [:owner_type]

  before_validation do
    self.year = Date.today.year if year.blank?
    self.month = Date.today.month if month.blank?
    self.amount_of_payment = ChargeSettings.entry_fee
  end
end
