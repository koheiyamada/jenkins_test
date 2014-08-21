class AddOriginalLessonFeeToAccountJournalEntries < ActiveRecord::Migration
  def change
  	add_column :account_journal_entries, :original_lesson_fee, :integer, default: 0
  end
end
