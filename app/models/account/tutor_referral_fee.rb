class Account::TutorReferralFee < Account::JournalEntry
  belongs_to :referral, class_name:Tutor.name
  attr_accessible :referral

  validates_presence_of :referral_id
  #validates_uniqueness_of :referral_id

  before_validation do
    self.year = Date.today.year
    self.month = Date.today.month
  end
end
