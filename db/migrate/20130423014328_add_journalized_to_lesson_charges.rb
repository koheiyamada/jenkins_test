class AddJournalizedToLessonCharges < ActiveRecord::Migration
  def change
    add_column :lesson_charges, :journalized, :boolean, :default => false
  end
end
