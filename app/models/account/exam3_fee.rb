class Account::Exam3Fee < Account::JournalEntry
  payer_type Student
  monthly_payment
  amount_given
  to_headquarter
end
