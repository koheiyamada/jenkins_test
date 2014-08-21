class RenameColumnLessonCancellationPemaltyOfLedgers < ActiveRecord::Migration
  def up
    rename_column :ledgers, :lesson_cancellation_pemalty, :lesson_cancellation_penalty
  end

  def down
    rename_column :ledgers, :lesson_cancellation_penalty, :lesson_cancellation_pemalty
  end
end
