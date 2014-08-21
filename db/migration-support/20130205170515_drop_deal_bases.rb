hq = Headquarter.instance
Account::JournalEntry.where(owner_id:hq.id, owner_type:"Organization").destroy_all
