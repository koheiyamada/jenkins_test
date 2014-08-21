class AddBeginningOfTermAndEndOfTermToExams < ActiveRecord::Migration
  def change
    add_column :exams, :beginning_of_term, :datetime
    add_column :exams, :end_of_term, :datetime
  end
end
