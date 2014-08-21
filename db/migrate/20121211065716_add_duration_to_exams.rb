class AddDurationToExams < ActiveRecord::Migration
  def change
    add_column :exams, :duration, :integer
  end
end
