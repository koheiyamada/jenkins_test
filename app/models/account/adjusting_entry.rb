class Account::AdjustingEntry < Account::JournalEntry
  before_validation :fill_empty_amounts

  def name
    if note.present?
      note
    else
      super
    end
  end

  private

    def fill_empty_amounts
      self.amount_of_money_received = 0 if amount_of_money_received.blank?
      self.amount_of_payment = 0        if amount_of_payment.blank?
    end
end
