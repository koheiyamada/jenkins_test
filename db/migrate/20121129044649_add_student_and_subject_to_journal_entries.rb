class AddStudentAndSubjectToJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :student_id, :integer
    add_column :account_journal_entries, :subject_id, :integer
    add_index :account_journal_entries, :student_id
    add_index :account_journal_entries, :subject_id
  end
end
