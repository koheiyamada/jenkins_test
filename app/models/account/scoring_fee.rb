class Account::ScoringFee < Account::JournalEntry
  monthly_payment(:student_id, :subject_id)
  amount_given
  belongs_to :student
  belongs_to :subject
  attr_accessible :student, :subject


  #validates_presence_of :student, :subject
end
