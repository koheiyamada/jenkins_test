class Headquarter < Organization
  class << self
    def instance
      first
    end
  end

  validates_presence_of :name

  def contactable_members
    HqUser.scoped()
  end

  def message_recipients
    HqUser.scoped()
  end

  def journal_entries
    # すべての仕訳は本部が相手
    Account::JournalEntry.scoped
  end

  def hq_users
    HqUser.where(organization_id:self.id)
  end
end
